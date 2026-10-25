# frozen_string_literal: true

require_relative "duel_helper"

# The hot path: a memoized method called again, after its first call
# stored the value. It reads the cache without taking the lock.

duel "read: a memoized method" do
  once { @object = OneMemoized.new.tap(&:value) }
  @object.value
end

duel "read: a frozen object's memoized method" do
  once { @object = OneMemoized.new.tap(&:value).freeze }
  @object.value
end
