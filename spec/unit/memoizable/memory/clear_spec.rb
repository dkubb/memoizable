require 'spec_helper'

describe Memoizable::Memory, '#clear' do
  subject { described_class.new(foo: 1) }

  shared_context '#clear behaviour' do
    it 'returns self' do
      expect(subject.clear).to be(subject)
    end

    it 'removes values' do
      subject.clear

      expect { subject[:foo] }.to raise_error(NameError)
    end
  end

  context 'without Monitor mocked' do
    include_examples '#clear behaviour'
  end

  context 'with Monitor mocked' do
    let(:monitor) { instance_double(Monitor) }

    before do
      allow(Monitor).to receive_messages(new: monitor)
      allow(monitor).to receive(:synchronize).and_yield
    end

    include_examples '#clear behaviour'

    it 'synchronizes concurrent updates' do
      subject.clear

      expect(monitor).to have_received(:synchronize).once
    end
  end
end
