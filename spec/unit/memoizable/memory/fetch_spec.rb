require 'spec_helper'

describe Memoizable::Memory, '#fetch' do
  subject { object.fetch(name) { default } }

  let(:object)  { described_class.new        }
  let(:name)    { :test                      }
  let(:default) { instance_double('Default') }
  let(:value)   { instance_double('Value')   }

  context 'when the events are not mocked' do
    let(:other) { instance_double('Other') }

    before do
      # Set other keys in memory
      object[:other] = other
      object[nil]    = nil
    end

    context 'when the memory is set' do
      before do
        object[name] = value
      end

      it 'returns the expected value' do
        expect(subject).to be(value)
      end

      it 'memoizes the value' do
        subject
        expect(object[name]).to be(value)
      end

      it 'does not overwrite the other key' do
        subject
        expect(object[:other]).to be(other)
      end
    end

    context 'when the memory is not set' do
      it 'returns the default value' do
        expect(subject).to be(default)
      end

      it 'memoizes the default value' do
        subject
        expect(object[name]).to be(default)
      end

      it 'does not overwrite the other key' do
        subject
        expect(object[:other]).to be(other)
      end
    end
  end

  context 'when the events are mocked' do
    def register_events(object, method_names)
      method_names.each do |method_name|
        allow(object).to receive(method_name) do |*args, &block|
          events.next.call(object, method_name, *args, &block)
        end
      end
    end

    def expected_event(object, method_name, *expected_args, &handler)
      ->(*args, &block) do
        expect(args).to eql([object, method_name, *expected_args])
        handler.call(&block)
      end
    end

    let(:cache) do
      instance_double(ThreadSafe::Cache).tap do |cache|
        register_events(cache, %i[fetch []=])
      end
    end

    let(:monitor) do
      instance_double(Monitor).tap do |monitor|
        register_events(monitor, %i[synchronize])
      end
    end

    before do
      allow(ThreadSafe::Cache).to receive(:new).and_return(cache)
      allow(Monitor).to receive(:new).and_return(monitor)
    end

    context 'when the memory is set on first #fetch' do
      let(:events) do
        Enumerator.new do |events|
          # First call to cache#fetch returns value
          events << expected_event(cache, :fetch, name) do
            value
          end
        end
      end

      it 'returns the expected value' do
        expect(subject).to be(value)
      end

      it 'executes all events' do
        subject
        expect { events.peek }.to raise_error(StopIteration)
      end
    end

    context 'when the memory is set on second #fetch' do
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

      it 'returns the expected value' do
        expect(subject).to be(value)
      end

      it 'executes all events' do
        subject
        expect { events.peek }.to raise_error(StopIteration)
      end
    end

    context 'when the memory is not set on second #fetch' do
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

      it 'returns the default value' do
        expect(subject).to be(default)
      end

      it 'executes all events' do
        subject
        expect { events.peek }.to raise_error(StopIteration)
      end
    end
  end
end
