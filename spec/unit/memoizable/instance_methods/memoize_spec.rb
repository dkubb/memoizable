# frozen_string_literal: true

require "spec_helper"
require File.expand_path("../fixtures/classes", __dir__)

RSpec.describe Memoizable::InstanceMethods, "#memoize" do
  subject(:memoize_value) { object.memoize(method => value) }

  let(:described_class) { Class.new(Fixture::Object) }
  let(:object) { described_class.new }
  let(:method) { :test }

  before do
    described_class.memoize(method)
  end

  context "when the method is not memoized" do
    let(:value) { "" }

    it "sets the memoized value for the method to the value" do
      memoize_value
      expect(object.send(method)).to be(value)
    end

    it_behaves_like "a command method"
  end

  context "when the method is already memoized" do
    let(:value) { double }
    let(:original) { nil }

    before do
      object.memoize(method => original)
    end

    it "raises an exception" do
      expect { memoize_value }.to raise_error(ArgumentError)
    end
  end
end
