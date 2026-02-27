# frozen_string_literal: true

require "spec_helper"

RSpec.describe Memoizable::Memory, "#delete" do
  subject(:memory) { described_class.new(foo: 1) }

  shared_examples "with #delete behaviour" do
    it "returns value at key" do
      expect(memory.delete(:foo)).to be(1)
    end

    it "removes key" do
      memory.delete(:foo)

      expect { memory[:foo] }.to raise_error(NameError)
    end
  end

  context "without Monitor mocked" do
    it_behaves_like "with #delete behaviour"
  end

  context "with Monitor mocked" do
    let(:monitor) { instance_double(Monitor) }

    before do
      allow(Monitor).to receive(:new).and_return(monitor)
      allow(monitor).to receive(:synchronize).and_yield
    end

    it_behaves_like "with #delete behaviour"

    it "synchronizes concurrent updates" do
      memory.delete(:foo)

      expect(monitor).to have_received(:synchronize).once
    end
  end
end
