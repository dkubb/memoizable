# frozen_string_literal: true

require "spec_helper"
require File.expand_path("../fixtures/classes", __dir__)

RSpec.shared_examples_for "memoizes method" do
  it "memoizes the instance method" do
    memoize_method
    instance = object.new
    first_call = instance.send(method)
    second_call = instance.send(method)
    expect(first_call).to be(second_call)
  end

  it "creates a zero arity method", unless: RUBY_VERSION == "1.8.7" do
    memoize_method
    expect(object.new.method(method).arity).to be_zero
  end

  context "when the initializer calls the memoized method" do
    before do
      method = self.method
      object.send(:define_method, :initialize) { send(method) }
    end

    it "allows the memoized method to be called within the initializer" do
      memoize_method
      expect { object.new }.not_to raise_error
    end
  end
end

RSpec.describe Memoizable::ModuleMethods, "#memoize" do
  subject(:memoize_method) { object.memoize(method) }

  let(:object) do
    stub_const "TestClass", Class.new(Fixture::Object) {
      def some_state
        Object.new
      end
    }
  end

  context "when method has required arguments" do
    let(:method) { :required_arguments }

    it "raises error" do
      expect { memoize_method }.to raise_error(
        Memoizable::MethodBuilder::InvalidArityError,
        "Cannot memoize TestClass#required_arguments, its arity is 1"
      )
    end
  end

  context "when method has optional arguments" do
    let(:method) { :optional_arguments }

    it "raises error" do
      expect { memoize_method }.to raise_error(
        Memoizable::MethodBuilder::InvalidArityError,
        "Cannot memoize TestClass#optional_arguments, its arity is -1"
      )
    end
  end

  context "with memoized method that returns generated values" do
    let(:method) { :some_state }

    it_behaves_like "a command method"
    it_behaves_like "memoizes method"

    it "creates a method that returns a frozen value" do
      memoize_method
      expect(object.new.send(method)).to be_frozen
    end
  end

  context "with public method" do
    let(:method) { :public_method }

    it_behaves_like "a command method"
    it_behaves_like "memoizes method"

    it "is still a public method" do
      expect(memoize_method).to be_public_method_defined(method)
    end

    it "creates a method that returns a frozen value" do
      memoize_method
      expect(object.new.send(method)).to be_frozen
    end
  end

  context "with protected method" do
    let(:method) { :protected_method }

    it_behaves_like "a command method"
    it_behaves_like "memoizes method"

    it "is still a protected method" do
      expect(memoize_method).to be_protected_method_defined(method)
    end

    it "creates a method that returns a frozen value" do
      memoize_method
      expect(object.new.send(method)).to be_frozen
    end
  end

  context "with private method" do
    let(:method) { :private_method }

    it_behaves_like "a command method"
    it_behaves_like "memoizes method"

    it "is still a private method" do
      expect(memoize_method).to be_private_method_defined(method)
    end

    it "creates a method that returns a frozen value" do
      memoize_method
      expect(object.new.send(method)).to be_frozen
    end
  end

  context "when the method was already memoized" do
    let(:method) { :test }

    before do
      object.memoize(method)
    end

    it "raises an error" do
      expect { memoize_method }.to raise_error(
        ArgumentError,
        "The method test is already memoized"
      )
    end
  end
end
