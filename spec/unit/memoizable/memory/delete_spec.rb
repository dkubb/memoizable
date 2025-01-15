require 'spec_helper'

describe Memoizable::Memory, '#delete' do
  subject { described_class.new(foo: 1) }

  it 'removes a specific value' do
    expect(subject.delete(:foo)).to be_nil
    expect { subject[:foo] }.to raise_error(NameError)
  end

  context 'with Monitor mocked' do
    let(:monitor) { instance_double(Monitor) }

    before do
      allow(Monitor).to receive(:new).and_return(monitor)
      allow(monitor).to receive(:synchronize).and_yield
    end

    it 'synchronizes concurrent updates' do
      subject.delete(:foo)
      expect(monitor).to have_received(:synchronize)
    end
  end
end
