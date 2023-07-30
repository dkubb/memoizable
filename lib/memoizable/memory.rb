# encoding: utf-8

module Memoizable

  # Storage for memoized methods
  class Memory

    # Initialize the memory storage for memoized methods
    #
    # @param [ThreadSafe::Cache] memory
    #
    # @return [undefined]
    #
    # @api private
    def initialize(memory)
      @memory  = memory
      @monitor = Monitor.new
      freeze
    end

    # Get the value from memory
    #
    # @example
    #
    #   memory = Memoizable::Memory.new(foo: 1)
    #   memory[:foo]  # => 1
    #
    # @param [Symbol] name
    #
    # @return [Object]
    #
    # @api public
    def [](name)
      fetch(name) do
        fail NameError, "No method #{name} is memoized"
      end
    end

    # Store the value in memory
    #
    # @example
    #   memory = Memoizable::Memory.new(foo: 1)
    #   memory[:foo] = 2
    #
    # @param [Symbol] name
    # @param [Object] value
    #
    # @return [undefined]
    #
    # @api public
    def []=(name, value)
      @monitor.synchronize do
        if @memory.key?(name)
          fail ArgumentError, "The method #{name} is already memoized"
        else
          @memory[name] = value
        end
      end
    end

    # Fetch the value from memory, or store it if it does not exist
    #
    # @example
    #   memory = Memoizable::Memory.new(foo: 1)
    #   memory.fetch(:foo) { 2 }  # => 1
    #   memory.fetch(:bar) { 2 }  # => 2
    #   memory[:bar]              # => 2
    #
    # @param [Symbol] name
    #
    # @yieldreturn [Object]
    #   the value to memoize
    #
    # @return [Object]
    #
    # @api public
    def fetch(name)
      @memory.fetch(name) do       # check for the key
        @monitor.synchronize do    # acquire a lock if the key is not found
          @memory.fetch(name) do   # recheck under lock
            @memory[name] = yield  # set the value
          end
        end
      end
    end

    # A hook that allows Marshal to dump the object
    #
    # @example
    #   memory = Memoizable::Memory.new(foo: 1)
    #   Marshal.dump(memory)  # => "\x04\bU:\x17Memoizable::Memory{\x06:\bfooi\x06"
    #
    # @return [Hash]
    #   A hash used to populate the internal memory
    #
    # @api public
    def marshal_dump
      @memory.marshal_dump
    end

    # A hook that allows Marshal to load the object
    #
    # @example
    #   memory = Memoizable::Memory.new(foo: 1)
    #   Marshal.load(Marshal.dump(memory))  # => #<Memoizable::Memory:0x007f9c2a8b6b20 @memory={:foo=>1}>
    #
    # @param [Hash] hash
    #   A hash used to populate the internal memory
    #
    # @return [undefined]
    #
    # @api public
    def marshal_load(hash)
      initialize(ThreadSafe::Cache.new)
      @memory.marshal_load(hash)
    end

  end # Memory
end # Memoizable
