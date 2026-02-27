# frozen_string_literal: true

require "spec_helper"

RSpec.describe Memoizable::Memory, "#marshal_load" do
  subject(:load_hash) { object.marshal_load(hash) }

  let(:object) { described_class.allocate }
  let(:hash) { {test: nil} }

  it "loads the hash into memory" do
    load_hash
    expect(object.fetch(:test)).to be_nil
  end

  it "freezes the object" do
    load_hash
    expect(object).to be_frozen
  end
end
