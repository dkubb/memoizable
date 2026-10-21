# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Memoizable::VERSION" do
  let(:version_file) { File.expand_path("../../../lib/memoizable/version.rb", __dir__) }
  let(:wrapper) { Module.new }

  it "defines the version the gem is packaged with" do
    load version_file, wrapper

    expect(wrapper::Memoizable::VERSION).to eq(Gem.loaded_specs.fetch("memoizable").version.to_s)
  end
end
