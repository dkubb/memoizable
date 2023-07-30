require 'spec_helper'

describe Memoizable::Memory, '#[]=' do
  subject { object[name] = value }

  let(:object) { described_class.new      }
  let(:name)   { :test                    }
  let(:value)  { instance_double('Value') }

  context 'when the events are not mocked' do
    context 'when the memory is set' do
      before do
        object[name] = value
      end

      it 'raises an exception' do
        expect { subject }.to raise_error(ArgumentError, 'The method test is already memoized')
      end
    end

    context 'when the memory is not set' do
      it 'set the value' do
        subject
        expect(object[name]).to be(value)
      end

      it 'returns the value' do
        expect(subject).to be(value)
      end
    end
  end

  context 'when the events are mocked' do
    include_context 'mocked events'

    let(:cache) do
      instance_double(ThreadSafe::Cache).tap do |cache|
        register_events(cache, %i[key? []=])
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

    context 'when the memory is set' do
      include_examples 'executes all events'

      let(:events) do
        Enumerator.new do |events|
          # Call to monitor#synchronize yields
          events << expected_event(monitor, :synchronize) do |&block|
            block.call
          end

          # Call to cache#key? returns true
          events << expected_event(cache, :key?, name) do
            true
          end
        end
      end

      it 'raises an exception' do
        expect { subject }.to raise_error(ArgumentError, 'The method test is already memoized')
      end
    end

    context 'when the memory is not set' do
      include_examples 'executes all events'

      let(:events) do
        Enumerator.new do |events|
          # Call to monitor#synchronize yields
          events << expected_event(monitor, :synchronize) do |&block|
            block.call
          end

          # Call to cache#key? returns false
          events << expected_event(cache, :key?, name) do
            false
          end

          # Call to cache#[]= sets and returns the value
          events << expected_event(cache, :[]=, name, value) do
            allow(cache).to receive(:fetch).with(name).and_return(value)
            value
          end
        end
      end

      it 'set the value' do
        subject
        expect(object[name]).to be(value)
      end

      it 'returns the value' do
        expect(subject).to be(value)
      end
    end
  end
end
