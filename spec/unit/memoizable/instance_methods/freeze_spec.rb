# frozen_string_literal: true

require "spec_helper"
require File.expand_path("../fixtures/classes", __dir__)

RSpec.describe Memoizable::InstanceMethods, "#freeze" do
  subject(:freeze_object) { object.freeze }

  let(:described_class) { Class.new(Fixture::Object) }
  let(:object) { described_class.allocate }

  before do
    described_class.memoize(:test)
  end

  it_behaves_like "a command method"

  it "freezes the object" do
    expect { freeze_object }.to change(object, :frozen?).from(false).to(true)
  end

  it "allows methods not yet called to be memoized" do
    freeze_object
    first_call = object.test
    second_call = object.test
    expect(first_call).to be(second_call)
  end
end
