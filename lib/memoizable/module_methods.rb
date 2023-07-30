# encoding: utf-8

module Memoizable

  # Methods mixed in to memoizable singleton classes
  module ModuleMethods
    include Memoizable

    # Return default deep freezer
    #
    # @return [#call]
    #
    # @api private
    def freezer
      Freezer
    end

    # Memoize a list of methods
    #
    # @example
    #   memoize :hash
    #
    # @param [Array<Symbol>] methods
    #   a list of methods to memoize
    #
    # @return [self]
    #
    # @api public
    def memoize(*methods)
      methods.each(&method(:memoize_method))
      self
    end

    # Return unmemoized instance method
    #
    # @example
    #
    #   class Foo
    #     include Memoizable
    #
    #     def bar
    #     end
    #     memoize :bar
    #   end
    #
    #   Foo.unmemoized_instance_method(:bar)
    #
    # @param [Symbol] name
    #
    # @return [UnboundMethod]
    #   the memoized method
    #
    # @raise [NameError]
    #   raised if the method is unknown
    #
    # @api public
    def unmemoized_instance_method(name)
      memoized_methods[name].original_method
    end

  private

    # Memoize the named method
    #
    # @param [Symbol] method_name
    #   a method name to memoize
    #
    # @return [undefined]
    #
    # @api private
    def memoize_method(method_name)
      memoized_methods[method_name] = MethodBuilder.new(
        self,
        method_name,
        freezer
      ).call
    end

    # Return method builder registry
    #
    # @return [Hash<Symbol, MethodBuilder>]
    #
    # @api private
    def memoized_methods
      @_memoized_methods ||= {}
    end

  end # ModuleMethods
end # Memoizable
