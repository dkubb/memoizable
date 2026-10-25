# frozen_string_literal: true

require_relative "duel_helper"

# Memoizable::Memory, the cache behind every memoized method, used
# directly through its public API.

duel "memory: [] a stored value" do
  once { @memory = Memoizable::Memory.new(value: 42) }
  @memory[:value]
end

duel "memory: fetch a missing key with a block" do |n|
  memories = untimed { Array.new(n) { Memoizable::Memory.new({}) } }
  memories.each { |memory| memory.fetch(:value, &COMPUTE) }
end
