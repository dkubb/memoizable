# frozen_string_literal: true

require "spec_helper"

RSpec.describe Memoizable::ModuleMethods, "#unmemoized_instance_method" do
  subject(:unmemoized_method) { object.unmemoized_instance_method(name) }

  let(:object) do
    Class.new do
      include Memoizable

      def initialize
        @foo = 0
      end

      def foo
        @foo += 1
      end

      memoize :foo
    end
  end

  context "when the method was memoized" do
    let(:name) { :foo }

    it { is_expected.to be_instance_of(UnboundMethod) }

    it "returns the original method" do
      # original method is not memoized
      method = unmemoized_method.bind(object.new)
      expect(method.call).not_to be(method.call)
    end
  end

  context "when the method was not memoized" do
    let(:name) { :bar }

    it "raises an exception" do
      expect { unmemoized_method }.to raise_error(NoMethodError)
    end
  end
end
