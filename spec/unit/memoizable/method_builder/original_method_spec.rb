# frozen_string_literal: true

require "spec_helper"

RSpec.describe Memoizable::MethodBuilder, "#original_method" do
  subject(:original_method) { object.original_method }

  let(:object) { described_class.new(descendant, method_name, freezer) }
  let(:method_name) { :foo }
  let(:freezer) { lambda(&:freeze) }

  let(:descendant) do
    Class.new do
      def initialize
        @foo = 0
      end

      def foo
        @foo += 1
      end
    end
  end

  it { is_expected.to be_instance_of(UnboundMethod) }

  it "returns the original method" do
    # original method is not memoized
    method = original_method.bind(descendant.new)
    expect(method.call).not_to be(method.call)
  end
end
