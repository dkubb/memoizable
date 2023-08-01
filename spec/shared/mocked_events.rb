shared_context 'mocked events' do
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
end

shared_examples 'executes all events' do
  it 'executes all events' do
    begin
      subject
    rescue
      # subject may raise, should be tested in other examples
    end
    expect { events.peek }.to raise_error(StopIteration)
  end
end
