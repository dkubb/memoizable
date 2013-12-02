module Memoizable

  # Storage for memoized methods
  class Memory

    def initialize
      @memory = ThreadSafe::Cache.new
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
      if key?(name)
        fail ArgumentError, "The method #{name} is already memoized"
      end
      @memory[name] = value
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
      @memory.fetch(name) { self[name] = yield }
    end

    # Set the memory
    #
    # @param [Hash]
    #
    # @return [Memory]
    #
    # @api public
    def set(data)
      data.each { |name, value| self[name] = value }
      self
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
