require 'spec_helper'

describe Memoizable::Memory, '#clear' do
  subject { described_class.new(foo: 1) }

  it 'returns nil' do
    expect(subject.clear).to be_nil
  end

  it 'removes values' do
    subject.clear
    expect { subject[:foo] }.to raise_error(NameError)
  end

  context 'with Monitor mocked' do
    let(:monitor) { instance_double(Monitor) }

    before do
      allow(Monitor).to receive(:new).and_return(monitor)
      allow(monitor).to receive(:synchronize).and_yield
    end

    it 'synchronizes concurrent updates' do
      subject.clear
      expect(monitor).to have_received(:synchronize)
    end
  end
end
