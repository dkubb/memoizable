# frozen_string_literal: true

require "spec_helper"
require File.expand_path("../../fixtures/classes", __dir__)

RSpec.describe Memoizable::MethodBuilder, ".new" do
  subject(:method_builder) { described_class.new(descendant, method_name, freezer) }

  let(:descendant) { Fixture::Object }
  let(:freezer) { lambda(&:freeze) }

  context "with a zero arity method" do
    let(:method_name) { :zero_arity }

    it { is_expected.to be_instance_of(described_class) }

    it "sets the original method" do
      # original method is not memoized
      method = method_builder.original_method.bind(descendant.new)
      expect(method.call).not_to be(method.call)
    end
  end

  context "with a one arity method" do
    let(:method_name) { :one_arity }

    it "raises an exception" do
      expect { method_builder }.to raise_error(
        described_class::InvalidArityError,
        "Cannot memoize Fixture::Object#one_arity, its arity is 1"
      )
    end
  end
end
