require 'spec_helper'

describe Memoizable::Memory, '#marshal_load' do
  subject { object.marshal_load(hash) }

  let(:object) { described_class.allocate }
  let(:hash)   { { test: nil }            }

  it 'loads the hash into memory' do
    subject
    expect(object.fetch(:test)).to be(nil)
  end

  it 'freezes the object' do
    subject
    expect(object).to be_frozen
  end
end
