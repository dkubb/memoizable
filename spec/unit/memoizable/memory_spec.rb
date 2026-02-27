# frozen_string_literal: true

require "spec_helper"

RSpec.describe Memoizable::Memory do
  let(:object) { described_class.new({}) }

  it "is frozen" do
    expect(object).to be_frozen
  end

  # This test will raise if mutant removes the @monitor assignment
  # in the constructor
  it "depends on the monitor" do
    expect(object.fetch(:test, :test)).to be(:test)
  end

  context "when serialized" do
    let(:deserialized) { Marshal.load(Marshal.dump(object)) }

    it "is serializable with Marshal" do
      expect { Marshal.dump(object) }.not_to raise_error
    end

    it "is deserializable with Marshal" do
      expect(deserialized).to be_an_instance_of(described_class)
    end

    it "mantains the same class of cache when deserialized" do
      original_cache = object.instance_variable_get(:@memory)
      deserialized_cache = deserialized.instance_variable_get(:@memory)

      expect(deserialized_cache.class).to eql(original_cache.class)
    end
  end
end
