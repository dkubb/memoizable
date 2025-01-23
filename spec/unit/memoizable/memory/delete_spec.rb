require 'spec_helper'

describe Memoizable::Memory, '#delete' do
  subject { described_class.new(foo: 1) }

  shared_context '#delete behaviour' do
    it 'returns value at key' do
      expect(subject.delete(:foo)).to be(1)
    end

    it 'removes key' do
      expect(subject[:foo]).to be(1)

      subject.delete(:foo)

      expect { subject[:foo] }.to raise_error(NameError)
    end
  end

  context 'without Monitor mocked' do
    include_examples '#delete behaviour'
  end

  context 'with Monitor mocked' do
    let(:monitor) { instance_double(Monitor) }

    before do
      allow(Monitor).to receive(:new).and_return(monitor)
      allow(monitor).to receive(:synchronize).and_yield
    end

    include_examples '#delete behaviour'

    it 'synchronizes concurrent updates' do
      subject.delete(:foo)

      expect(monitor).to have_received(:synchronize).once
    end
  end
end
