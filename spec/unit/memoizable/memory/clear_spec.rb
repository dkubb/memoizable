# frozen_string_literal: true

require "spec_helper"

RSpec.describe Memoizable::Memory, "#clear" do
  subject(:memory) { described_class.new(foo: 1) }

  shared_examples "with #clear behaviour" do
    it "returns self" do
      expect(memory.clear).to be(memory)
    end

    it "removes values" do
      memory.clear

      expect { memory[:foo] }.to raise_error(NameError)
    end
  end

  context "without Monitor mocked" do
    it_behaves_like "with #clear behaviour"
  end

  context "with Monitor mocked" do
    let(:monitor) { instance_double(Monitor) }

    before do
      allow(Monitor).to receive_messages(new: monitor)
      allow(monitor).to receive(:synchronize).and_yield
    end

    it_behaves_like "with #clear behaviour"

    it "synchronizes concurrent updates" do
      memory.clear

      expect(monitor).to have_received(:synchronize).once
    end
  end
end
