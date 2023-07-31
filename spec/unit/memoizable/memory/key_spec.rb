require 'spec_helper'

describe Memoizable::Memory, '#key?' do
  subject { object.key?(name) }

  let(:object) { described_class.new }
  let(:name)   { :test               }

  context 'when the key is present' do
    it 'returns true' do
      object[name] = nil
      expect(object.key?(name)).to be(true)
    end
  end

  context 'when the key is not present' do
    it 'returns false' do
      expect(object.key?(name)).to be(false)
    end
  end
end
