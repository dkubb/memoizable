module Memoizable

  # Build the memoized method
  class MethodBuilder

    # Raised when the method arity is invalid
    class InvalidArityError < ArgumentError

      # Initialize an invalid arity exception
      #
      # @param [Module] descendant
      # @param [Symbol] method
      # @param [Integer] arity
      #
      # @api private
      def initialize(descendant, method, arity)
        super("Cannot memoize #{descendant}##{method}, it's arity is #{arity}")
      end

    end # InvalidArityError

    # The original method before memoization
    #
    # @return [UnboundMethod]
    #
    # @api public
    attr_reader :original_method

    # Initialize an object to build a memoized method
    #
    # @param [Module] descendant
    # @param [Symbol] method_name
    #
    # @return [undefined]
    #
    # @api private
    def initialize(descendant, method_name)
      @descendant          = descendant
      @method_name         = method_name
      @original_visibility = visibility
      @original_method     = @descendant.instance_method(@method_name)
      assert_zero_arity
    end

    # Build a new memoized method
    #
    # @example
    #   method_builder.call  # => creates new method
    #
    # @return [MethodBuilder]
    #
    # @api public
    def call
      remove_original_method
      create_memoized_method
      set_method_visibility
      self
    end

  private

    # Assert the method arity is zero
    #
    # @return [undefined]
    #
    # @raise [InvalidArityError]
    #
    # @api private
    def assert_zero_arity
      arity = @original_method.arity
      if arity.nonzero?
        raise InvalidArityError.new(@descendant, @method_name, arity)
      end
    end

    # Remove the original method
    #
    # @return [undefined]
    #
    # @api private
    def remove_original_method
      descendant_exec(@method_name) { |name| undef_method(name) }
    end

    # Create a new memoized method
    #
    # @return [undefined]
    #
    # @api private
    def create_memoized_method
      descendant_exec(@method_name, @original_method) do |name, method|
        define_method(name) do ||
          memoized_method_cache.fetch(name, &method.bind(self))
        end
      end
    end

    # Set the memoized method visibility to match the original method
    #
    # @return [undefined]
    #
    # @api private
    def set_method_visibility
      descendant_exec(@method_name, @original_visibility) do |name, visibility|
        send(visibility, name)
      end
    end

    # Get the visibility of the original method
    #
    # @return [Symbol]
    #
    # @api private
    def visibility
      if    @descendant.private_method_defined?(@method_name)   then :private
      elsif @descendant.protected_method_defined?(@method_name) then :protected
      else                                                           :public
      end
    end

    # Helper method to execute code within the descendant scope
    #
    # @param [Array] args
    #
    # @return [undefined]
    #
    # @api private
    def descendant_exec(*args, &block)
      @descendant.instance_exec(*args, &block)
    end

  end # MethodBuilder
end # Memoizable
