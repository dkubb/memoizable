# frozen_string_literal: true

# The benchmarks memoize one method on each object. A cache is keyed by
# [class, name] arrays, whose hashes differ from one process to the
# next, so how often a lookup in a cache of several keys meets another
# key's hash, and the work that costs, differs between workers. A cache
# of one key never meets another.
require_relative "fixtures/one_memoized"

# The value to store with Memoizable::InstanceMethods#memoize.
MEMOIZE_DATA = {value: 42}.freeze

# The block that Memoizable::Memory#fetch computes a missing value with,
# as a memoized method passes one.
COMPUTE = -> { 42 }

# A new class with an unmemoized method named value, to memoize.
def unmemoized_class
  Class.new do
    include Memoizable

    def value
      42
    end
  end
end
