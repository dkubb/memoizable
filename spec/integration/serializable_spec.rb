# encoding: utf-8

require 'spec_helper'

class Serializable
  include Memoizable
  def method; end
  memoize :method
end

describe 'A serializable object' do
  let(:serializable) do
    Serializable.new
  end
  it 'is serializable with Marshal' do
    serializable.method # Call the method to trigger lazy memoization
    expect { Marshal.dump(serializable) }.not_to raise_error
  end
end
