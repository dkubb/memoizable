# encoding: utf-8

module Memoizable

  # Methods mixed in to memoizable instances
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
    #   object.memoize(hash: 12345)
    #
    # @param [Hash{Symbol => Object}] data
    #   the data to memoize
    #
    # @return [self]
    #
    # @api public
    def memoize(data)
      memoized_method_cache.set(data)
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
end # Memoizable