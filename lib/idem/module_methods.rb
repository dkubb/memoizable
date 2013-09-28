# encoding: utf-8

module Idem

  # Methods mixed in to idem singleton classes
  module ModuleMethods

    # Return default deep freezer
    #
    # @return [#call]
    #
    # @api private
    #
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

    # Test if an instance method is memoized
    #
    # @example
    #   class Foo
    #     include Idem
    #
    #     def bar
    #     end
    #     memoize :bar
    #   end
    #
    #   Foo.memoized?(:bar)  # true
    #   Foo.memoized?(:baz)  # false
    #
    # @param [Symbol] name
    #
    # @return [Boolean]
    #   true if method is memoized, false if not
    #
    # @api private
    def memoized?(name)
      memoized_methods.key?(name)
    end

    # Return original instance method
    #
    # @example
    #
    #   class Foo
    #     include Idem
    #
    #     def bar
    #     end
    #     memoize :bar
    #   end
    #
    #   Foo.original_instance_method(:bar)  # => UnboundMethod, where source_location still points to original!
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
    def original_instance_method(name)
      memoized_methods[name]
    end

  private

    # Memoize the named method
    #
    # @param [#to_s] method_name
    #   a method name to memoize
    # @param [#call] freezer
    #   a freezer for memoized values
    #
    # @return [undefined]
    #
    # @api private
    def memoize_method(method_name)
      method = instance_method(method_name)
      if method.arity.nonzero?
        raise ArgumentError, 'Cannot memoize method with nonzero arity'
      end
      memoized_methods[method_name] = method
      visibility = method_visibility(method_name)
      define_memoize_method(method)
      send(visibility, method_name)
    end

    # Return original method registry
    #
    # @return [Hash<Symbol, UnboundMethod>]
    #
    # @api private
    #
    def memoized_methods
      @__memoized_methods ||= Memory.new(freezer)
    end

    # Define a memoized method that delegates to the original method
    #
    # @param [UnboundMethod] method
    #   the method to memoize
    #
    # @return [undefined]
    #
    # @api private
    def define_memoize_method(method)
      name = method.name.to_sym
      undef_method(name)
      define_method(name) do ||
        memory.fetch(name) { method.bind(self).call }
      end
    end

    # Return the method visibility of a method
    #
    # @param [String, Symbol] method
    #   the name of the method
    #
    # @return [Symbol]
    #
    # @api private
    def method_visibility(method)
      if    private_method_defined?(method)   then :private
      elsif protected_method_defined?(method) then :protected
      else                                         :public
      end
    end

  end # ModuleMethods
end # Idem
