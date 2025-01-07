require 'spec_helper'

describe Memoizable::Memory, '#delete' do
  subject { described_class.new(foo: 1) }

  it 'removes a specific value' do
    expect(subject.delete(:foo)).to be_nil
    expect { subject[:foo] }.to raise_error(NameError)
  end
end
