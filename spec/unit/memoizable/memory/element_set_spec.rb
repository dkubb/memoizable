require 'spec_helper'

describe Memoizable::Memory, '#[]=' do
  subject { object[name] = value }

  let(:object) { described_class.new      }
  let(:name)   { :test                    }
  let(:value)  { instance_double('Value') }

  context 'when the memory is set' do
    before do
      object[name] = value
    end

    it 'raises an exception' do
      expect { subject }.to raise_error(ArgumentError, 'The method test is already memoized')
    end
  end

  context 'when the memory is not set' do
    it 'set the value' do
      subject
      expect(object[name]).to be(value)
    end

    it 'returns the value' do
      expect(subject).to be(value)
    end
  end
end
