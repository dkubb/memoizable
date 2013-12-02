# encoding: utf-8

require 'spec_helper'

describe Memoizable::ModuleMethods, '#unmemoized_instance_method' do
  subject { object.unmemoized_instance_method(name) }

  let(:object) do
    Class.new do
      include Memoizable

      def foo; end

      alias_method :original_foo, :foo
      memoize :foo
    end
  end

  context 'when the method was memoized' do
    let(:name) { :foo }

    it 'returns the original method' do
      should eql(object.instance_method(:original_foo))
    end

    it 'is different from the memoized method' do
      should_not eql(object.instance_method(:foo))
    end
  end

  context 'when the method was not memoized' do
    let(:name) { :bar }

    it 'raises an exception' do
      expect { subject }.to raise_error(NameError, 'No method bar is memoized')
    end
  end
end
