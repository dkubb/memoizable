# encoding: utf-8

module Memoizable

  # Storage for memoized methods
  class Memory

    # Initialize the memory storage for memoized methods
    #
    # @return [undefined]
    #
    # @api private
    def initialize
      @memory  = ThreadSafe::Cache.new
      @monitor = Monitor.new
      freeze
    end

    # Get the value from memory
    #
    # @param [Symbol] name
    #
    # @return [Object]
    #
    # @api public
    def [](name)
      @memory.fetch(name) do
        fail NameError, "No method #{name} is memoized"
      end
    end

    # Store the value in memory
    #
    # @param [Symbol] name
    # @param [Object] value
    #
    # @return [undefined]
    #
    # @api public
    def []=(name, value)
      memoized = true
      @memory.compute_if_absent(name) do
        memoized = false
        value
      end
      fail ArgumentError, "The method #{name} is already memoized" if memoized
    end

    # Fetch the value from memory, or store it if it does not exist
    #
    # @param [Symbol] name
    #
    # @yieldreturn [Object]
    #   the value to memoize
    #
    # @api public
    def fetch(name)
      @memory.fetch(name) do       # check for the key
        @monitor.synchronize do    # acquire a lock if the key is not found
          @memory.fetch(name) do   # recheck under lock
            self[name] = yield     # set the value
          end
        end
      end
    end

    # Test if the name has a value in memory
    #
    # @param [Symbol] name
    #
    # @return [Boolean]
    #
    # @api public
    def key?(name)
      @memory.key?(name)
    end

  end # Memory
end # Memoizable
