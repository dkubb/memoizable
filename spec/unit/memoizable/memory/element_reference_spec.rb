# frozen_string_literal: true

require "spec_helper"

RSpec.describe Memoizable::Memory, "#[]" do
  subject(:fetch_value) { object[name] }

  let(:object) { described_class.new({}) }
  let(:name) { :test }

  context "when the memory is set" do
    let(:value) { instance_double("Value") }

    before do
      object.store(name, value)
    end

    it "returns the expected value" do
      expect(fetch_value).to be(value)
    end
  end

  context "when the memory is not set" do
    it "raises an exception" do
      expect { fetch_value }.to raise_error(NameError, "No method test is memoized")
    end
  end
end
