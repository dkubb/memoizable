# frozen_string_literal: true

# A class with one memoized method, the common case.
class OneMemoized
  include Memoizable

  def value
    42
  end
  memoize :value
end
