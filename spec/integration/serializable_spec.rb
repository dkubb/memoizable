# frozen_string_literal: true

require "spec_helper"

class Serializable
  include Memoizable

  def random_number
    rand(10_000)
  end
  memoize :random_number
end

RSpec.describe Serializable do
  let(:serializable) do
    described_class.new
  end

  before do
    # Call the memoized method to trigger lazy memoization
    serializable.random_number
  end

  it "is serializable with Marshal" do
    expect { Marshal.dump(serializable) }.not_to raise_error
  end

  it "is deserializable with Marshal" do
    serialized = Marshal.dump(serializable)
    deserialized = Marshal.load(serialized)

    expect(deserialized).to be_an_instance_of(described_class)
  end

  it "preserves memoized values after deserialization" do
    serialized = Marshal.dump(serializable)
    deserialized = Marshal.load(serialized)

    expect(deserialized.random_number).to eql(serializable.random_number)
  end
end
