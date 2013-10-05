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
      memoized_method_cache  # initialize method cache
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
      memoized_method_cache[name]
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
      memoized_method_cache[name] = value
      self
    end

  private

    # The memoized method results
    #
    # @return [Hash]
    #
    # @api private
    def memoized_method_cache
      @__memoized_method_cache ||= Memory.new(self.class.freezer)
    end

  end # InstanceMethods
end # Idem
