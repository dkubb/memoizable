# frozen_string_literal: true

require "spec_helper"

class Parent
  include Memoizable

  def foo
    @foo_call_count ||= 0
    @foo_call_count += 1
  end
  memoize :foo

  attr_reader :foo_call_count
end

class Child < Parent
  def foo
    @child_foo_call_count ||= 0
    @child_foo_call_count += 1
    super + 100
  end
  memoize :foo

  attr_reader :child_foo_call_count
end

RSpec.describe Child do
  subject(:child) { described_class.new }

  before do
    child.foo
  end

  it "allows subclass to override and memoize a parent memoized method" do
    expect(child.foo).to eq(101)
  end

  it "memoizes the child method" do
    expect(child.child_foo_call_count).to eq(1)
  end

  it "memoizes the parent method" do
    expect(child.foo_call_count).to eq(1)
  end

  it "stores the parent memoized value under its own cache key" do
    cache = child.instance_variable_get(:@_memoized_method_cache)
    memory = cache.instance_variable_get(:@memory)

    expect(memory[[Parent, :foo]]).to eq(1)
  end

  it "stores the child memoized value under its own cache key" do
    cache = child.instance_variable_get(:@_memoized_method_cache)
    memory = cache.instance_variable_get(:@memory)

    expect(memory[[described_class, :foo]]).to eq(101)
  end

  it "reuses parent memoized value when child cache is cleared" do
    child.instance_variable_get(:@_memoized_method_cache).delete([described_class, :foo])
    child.foo

    expect(child.foo_call_count).to eq(1)
  end

  it "recomputes child value when child cache is cleared" do
    child.instance_variable_get(:@_memoized_method_cache).delete([described_class, :foo])
    child.foo

    expect(child.child_foo_call_count).to eq(2)
  end
end
