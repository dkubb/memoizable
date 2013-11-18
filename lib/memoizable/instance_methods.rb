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
      @_memoized_method_cache ||= Memory.new(self.class.freezer)
    end

  end # InstanceMethods
end # Memoizable
