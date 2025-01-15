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
end
