# encoding: utf-8

module Idem

  # Methods mixed in to idem instances
  module InstanceMethods

    # Freeze the object
    #
    # @example
    #   object.freeze  # object is now frozen
    #
    # @return [Object]
    #
    # @api public
    def freeze
      memory  # initialize memory
      super
    end

    # Get the memoized value for a method
    #
    # @example
    #   hash = object.memoized(:hash)
    #
    # @param [Symbol] name
    #   the method name
    #
    # @return [Object]
    #
    # @api public
    def memoized(name)
      memory[name]
    end

    # Sets a memoized value for a method
    #
    # @example
    #   object.memoize(:hash, 12345)
    #
    # @param [Symbol] name
    #   the method name
    # @param [Object] value
    #   the value to memoize
    #
    # @return [self]
    #
    # @api public
    def memoize(name, value)
      memory[name] = value
      self
    end

  private

    # The memoized method results
    #
    # @return [Hash]
    #
    # @api private
    def memory
      @__memory ||= Memory.new(self.class.freezer)
    end

  end # InstanceMethods
end # Idem
