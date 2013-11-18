require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

shared_examples_for 'memoizes method' do
  it 'memoizes the instance method' do
    subject
    instance = object.new
    expect(instance.send(method)).to be(instance.send(method))
  end

  it 'creates a method that returns a same value' do
    subject
    instance = object.new
    expect(instance.send(method)).to be(instance.send(method))
  end

  it 'creates a method with an arity of 0' do
    subject
    expect(object.new.method(method).arity).to be_zero
  end

  context 'when the initializer calls the memoized method' do
    before do
      method = self.method
      object.send(:define_method, :initialize) { send(method) }
    end

    it 'allows the memoized method to be called within the initializer' do
      subject
      expect { object.new }.to_not raise_error
    end
  end
end

shared_examples_for 'a command method' do
  it 'returns self' do
    should equal(object)
  end
end

describe Memoizable::ModuleMethods, '#memoize' do
  subject { object.memoize(method) }

  let(:object) do
    Class.new(MemoizableSpecs::Object) do
      def some_state
        Object.new
      end
    end
  end

  context 'on method with arguments' do
    let(:method) { :argumented }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError, 'Cannot memoize method with nonzero arity')
    end
  end

  context 'memoized method that returns generated values' do
    let(:method) { :some_state }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.new.send(method)).to be_frozen
    end
  end

  context 'public method' do
    let(:method) { :public_method }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a public method' do
      should be_public_method_defined(method)
    end

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.new.send(method)).to be_frozen
    end
  end

  context 'protected method' do
    let(:method) { :protected_method }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a protected method' do
      should be_protected_method_defined(method)
    end

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.new.send(method)).to be_frozen
    end
  end

  context 'private method' do
    let(:method) { :private_method }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a private method' do
      should be_private_method_defined(method)
    end

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.new.send(method)).to be_frozen
    end
  end
end