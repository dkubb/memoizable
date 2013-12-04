# encoding: utf-8

require 'spec_helper'
require File.expand_path('../../fixtures/classes', __FILE__)

describe Memoizable::MethodBuilder, '#call' do
  subject { object.call }

  let(:object)     { described_class.new(descendant, method_name, freezer) }
  let(:descendant) { Fixture::Object                                       }
  let(:freezer)    { lambda { |object| object.freeze }                     }

  around do |example|
    # Restore original method after each example
    method_name = self.method_name
    original    = "original_#{method_name}"
    descendant.class_eval do
      alias_method original, method_name
      example.call
      undef_method method_name
      alias_method method_name, original
    end
  end

  shared_examples_for 'Memoizable::MethodBuilder#call' do
    it_should_behave_like 'a command method'

    it 'creates a method that is memoized' do
      subject
      instance = descendant.new
      expect(instance.send(method_name)).to be(instance.send(method_name))
    end

    it 'creates a method that returns a frozen value' do
      subject
      expect(descendant.new.send(method_name)).to be_frozen
    end
  end

  context 'public method' do
    let(:method_name) { :public_method }

    it_should_behave_like 'Memoizable::MethodBuilder#call'

    it 'creates a public memoized method' do
      subject
      expect(descendant).to be_public_method_defined(method_name)
    end
  end

  context 'protected method' do
    let(:method_name) { :protected_method }

    it_should_behave_like 'Memoizable::MethodBuilder#call'

    it 'creates a protected memoized method' do
      subject
      expect(descendant).to be_protected_method_defined(method_name)
    end

  end

  context 'private method' do
    let(:method_name) { :private_method }

    it_should_behave_like 'Memoizable::MethodBuilder#call'

    it 'creates a private memoized method' do
      subject
      expect(descendant).to be_private_method_defined(method_name)
    end
  end
end
