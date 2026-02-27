# frozen_string_literal: true

RSpec.shared_examples_for "a command method" do
  it "returns self" do
    expect(subject).to equal(object)
  end
end
