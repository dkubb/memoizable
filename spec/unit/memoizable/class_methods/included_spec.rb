# frozen_string_literal: true

require "spec_helper"

RSpec.describe Memoizable, ".included" do
  subject(:include_memoizable) { object.class_eval { include Memoizable } }

  let(:object) { Class.new }
  let(:superclass) { Module }

  it_behaves_like "it calls super", :included

  it "extends the descendant with module methods" do
    include_memoizable
    extended_modules = class << object; included_modules end
    expect(extended_modules).to include(Memoizable::ModuleMethods)
  end
end
