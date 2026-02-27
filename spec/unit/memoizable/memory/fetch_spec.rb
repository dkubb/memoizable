# frozen_string_literal: true

require "spec_helper"

RSpec.describe Memoizable::Memory, "#fetch" do
  subject(:fetch_result) { object.fetch(name) { default } }

  let(:object) { described_class.new(cache) }
  let(:cache) { {} }
  let(:name) { :test }
  let(:default) { instance_double("Default") }
  let(:value) { instance_double("Value") }

  context "when the events are not mocked" do
    let(:other) { instance_double("Other") }

    before do
      # Set other keys in memory
      object.store(:other, other)
      object.store(nil, nil)
    end

    context "when the memory is set" do
      before do
        object.store(name, value)
      end

      it "returns the expected value" do
        expect(fetch_result).to be(value)
      end

      it "memoizes the value" do
        fetch_result
        expect(object[name]).to be(value)
      end

      it "does not overwrite the other key" do
        fetch_result
        expect(object[:other]).to be(other)
      end
    end

    context "when the memory is not set" do
      it "returns the default value" do
        expect(fetch_result).to be(default)
      end

      it "memoizes the default value" do
        fetch_result
        expect(object[name]).to be(default)
      end

      it "does not overwrite the other key" do
        fetch_result
        expect(object[:other]).to be(other)
      end
    end

    context "with a default argument instead of a block" do
      it "returns the default argument when the key is not found" do
        expect(object.fetch(name, :default_value)).to be(:default_value)
      end

      it "memoizes the default argument" do
        object.fetch(name, :default_value)
        expect(object[name]).to be(:default_value)
      end

      it "returns the stored value when the key is found" do
        object.store(name, value)
        expect(object.fetch(name, :default_value)).to be(value)
      end

      it "allows nil as a default value" do
        expect(object.fetch(name, nil)).to be_nil
      end
    end

    context "with no default argument or block" do
      it "raises KeyError when the key is not found" do
        expect { object.fetch(name) }.to raise_error(KeyError, "key not found: :test")
      end
    end
  end

  context "when the events are mocked" do
    include_context "with mocked events"

    let(:cache) do
      instance_double(Hash).tap do |cache|
        register_events(cache, %i[fetch []=])
      end
    end

    let(:monitor) do
      instance_double(Monitor).tap do |monitor|
        register_events(monitor, %i[synchronize])
      end
    end

    before do
      allow(Monitor).to receive(:new).and_return(monitor)
    end

    context "when the memory is set on first #fetch" do
      let(:events) do
        Enumerator.new do |events|
          # First call to cache#fetch returns value
          events << expected_event(cache, :fetch, name) do
            value
          end
        end
      end

      it_behaves_like "executes all events"

      it "returns the expected value" do
        expect(fetch_result).to be(value)
      end

      it "executes all events" do
        fetch_result
        expect { events.peek }.to raise_error(StopIteration)
      end
    end

    context "when the memory is set on second #fetch" do
      let(:events) do
        Enumerator.new do |events|
          # First call to cache#fetch yields
          events << expected_event(cache, :fetch, name) do |&block|
            block.call
          end

          # Call to monitor#synchronize yields
          events << expected_event(monitor, :synchronize) do |&block|
            block.call
          end

          # Second call to cache#fetch returns value
          events << expected_event(cache, :fetch, name) do
            value
          end
        end
      end

      it_behaves_like "executes all events"

      it "returns the expected value" do
        expect(fetch_result).to be(value)
      end
    end

    context "when the memory is not set on second #fetch" do
      let(:events) do
        Enumerator.new do |events|
          # First call to cache#fetch yields
          events << expected_event(cache, :fetch, name) do |&block|
            block.call
          end

          # Call to monitor#synchronize yields
          events << expected_event(monitor, :synchronize) do |&block|
            block.call
          end

          # Second call to cache#fetch yields
          events << expected_event(cache, :fetch, name) do |&block|
            block.call
          end

          # Call to cache#[]= sets and returns the value
          events << expected_event(cache, :[]=, name, default) do
            default
          end
        end
      end

      it_behaves_like "executes all events"

      it "returns the default value" do
        expect(fetch_result).to be(default)
      end
    end
  end
end
