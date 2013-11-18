module MemoizableSpecs
  class Object
    include Memoizable

    def required_arguments(foo)
    end

    def optional_arguments(foo = nil)
    end

    def test
      'test'
    end

    def public_method
      caller
    end

  protected

    def protected_method
      caller
    end

  private

    def private_method
      caller
    end

  end # class Object
end # module MemoizableSpecs
