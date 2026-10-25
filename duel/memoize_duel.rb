# frozen_string_literal: true

require_relative "duel_helper"

# Setting a memoized value directly with #memoize, which makes the
# object's cache and stores the value under the lock. A single store is
# too short for its CPU time to settle, so each iteration makes 8.
duel "memoize: store a value on 8 new objects" do
  8.times { OneMemoized.new.memoize(MEMOIZE_DATA) }
end

# Memoizing a method on a class, which wraps it in a memoized method.
# Each iteration memoizes a fresh class, made outside the timing.
duel "define: memoize a method on a class" do |n|
  classes = untimed { Array.new(n) { unmemoized_class } }
  classes.each { |klass| klass.memoize(:value) }
end
