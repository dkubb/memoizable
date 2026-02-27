# frozen_string_literal: true

require "spec_helper"
require File.expand_path("../fixtures/classes", __dir__)

RSpec.describe Memoizable::MethodBuilder, "#call" do
  subject(:build_method) { object.call }

  let(:object) { described_class.new(descendant, method_name, freezer) }
  let(:freezer) { lambda(&:freeze) }
  let(:instance) { descendant.new }

  let(:descendant) do
    Class.new do
      include Memoizable

      def public_method
        __method__.to_s
      end

      def protected_method
        __method__.to_s
      end
      protected :protected_method

      def private_method
        __method__.to_s
      end
      private :private_method

      def other_method
        __method__.to_s
      end
      memoize :other_method
    end
  end

  shared_examples_for "Memoizable::MethodBuilder#call" do
    it_behaves_like "a command method"

    it "creates a method without warning to stderr" do
      expect { build_method }.not_to output.to_stderr
    end

    it "creates a method that is memoized" do
      build_method
      first_call = instance.send(method_name)
      second_call = instance.send(method_name)
      expect(first_call).to be(second_call)
    end

    it "creates a method that returns the expected value" do
      build_method
      expect(instance.send(method_name)).to eql(method_name.to_s)
    end

    it "creates a method that returns a frozen value" do
      build_method
      expect(descendant.new.send(method_name)).to be_frozen
    end

    it "creates a method that does not accept a block" do
      build_method
      # rubocop:disable Lint/EmptyBlock
      expect { descendant.new.send(method_name) {} }.to raise_error(
        # rubocop:enable Lint/EmptyBlock
        described_class::BlockNotAllowedError,
        "Cannot pass a block to #{descendant}##{method_name}, it is memoized"
      )
    end

    it "does not overwrite the cache for other methods", :aggregate_failures do
      # This test will fail if the cache key is `nil` because the cache
      # will be populated by the first call and the second call to the
      # other method will return the wrong cached entry.
      build_method
      expect(instance.send(method_name)).to eql(method_name.to_s)
      expect(instance.other_method).to eql("other_method")
    end

    it "uses a composite cache key of [descendant, method_name]" do
      build_method
      instance.send(method_name)
      cache = instance.instance_variable_get(:@_memoized_method_cache)
      memory = cache.instance_variable_get(:@memory)

      expect(memory.keys).to include([descendant, method_name])
    end
  end

  context "with public method" do
    let(:method_name) { :public_method }

    it_behaves_like "Memoizable::MethodBuilder#call"

    it "creates a public memoized method" do
      build_method
      expect(descendant).to be_public_method_defined(method_name)
    end
  end

  context "with protected method" do
    let(:method_name) { :protected_method }

    it_behaves_like "Memoizable::MethodBuilder#call"

    it "creates a protected memoized method" do
      build_method
      expect(descendant).to be_protected_method_defined(method_name)
    end
  end

  context "with private method" do
    let(:method_name) { :private_method }

    it_behaves_like "Memoizable::MethodBuilder#call"

    it "creates a private memoized method" do
      build_method
      expect(descendant).to be_private_method_defined(method_name)
    end
  end
end
