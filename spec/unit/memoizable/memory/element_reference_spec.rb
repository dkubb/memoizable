require 'spec_helper'

describe Memoizable::Memory, '#[]' do
  subject { object[name] }

  let(:object) { described_class.new(ThreadSafe::Cache.new) }
  let(:name)   { :test                                      }

  context 'when the memory is set' do
    let(:value) { instance_double('Value') }

    before do
      object[name] = value
    end

    it 'returns the expected value' do
      expect(subject).to be(value)
    end
  end

  context 'when the memory is not set' do
    it 'raises an exception' do
      expect { subject }.to raise_error(NameError, 'No method test is memoized')
    end
  end
end
