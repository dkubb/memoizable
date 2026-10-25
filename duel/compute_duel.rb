# frozen_string_literal: true

require_relative "duel_helper"

# The first call to a memoized method on a new object: it makes the
# object's cache, finds no value, takes the lock, calls the original
# method, freezes the result and stores it. A single first call is too
# short for its CPU time to settle, so each iteration makes 8.
duel "compute: first calls on 8 new objects" do
  8.times { OneMemoized.new.value }
end
