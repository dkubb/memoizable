# Memoizable

[![Gem Version](http://img.shields.io/gem/v/memoizable.svg)][gem]
[![Test](https://github.com/dkubb/memoizable/actions/workflows/test.yml/badge.svg)][test]
[![Lint](https://github.com/dkubb/memoizable/actions/workflows/lint.yml/badge.svg)][lint]
[![Mutant](https://github.com/dkubb/memoizable/actions/workflows/mutant.yml/badge.svg)][mutant]
[![Docs](https://github.com/dkubb/memoizable/actions/workflows/docs.yml/badge.svg)][docs]
[![Steep](https://github.com/dkubb/memoizable/actions/workflows/steep.yml/badge.svg)][steep]

[gem]: https://rubygems.org/gems/memoizable
[test]: https://github.com/dkubb/memoizable/actions/workflows/test.yml
[lint]: https://github.com/dkubb/memoizable/actions/workflows/lint.yml
[mutant]: https://github.com/dkubb/memoizable/actions/workflows/mutant.yml
[docs]: https://github.com/dkubb/memoizable/actions/workflows/docs.yml
[steep]: https://github.com/dkubb/memoizable/actions/workflows/steep.yml

Memoize method return values

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for details.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Rationale

Memoization is an optimization that saves the return value of a method so it
doesn't need to be re-computed every time that method is called. For example,
perhaps you've written a method like this:

```ruby
class Planet
  # This is the equation for the area of a sphere. If it's true for a
  # particular instance of a planet, then that planet is spherical.
  def spherical?
    4 * Math::PI * radius ** 2 == area
  end
end
```

This code will re-compute whether a particular planet is spherical every time
the method is called. If the method is called more than once, it may be more
efficient to save the computed value in an instance variable, like so:

```ruby
class Planet
  def spherical?
    @spherical ||= 4 * Math::PI * radius ** 2 == area
  end
end
```

One problem with this approach is that, if the return value is `false`, the
value will still be computed each time the method is called. It also becomes
unweildy for methods that grow to be longer than one line.

These problems can be solved by mixing-in the `Memoizable` module and memoizing
the method.

```ruby
require 'memoizable'

class Planet
  include Memoizable
  def spherical?
    4 * Math::PI * radius ** 2 == area
  end
  memoize :spherical?
end
```

## Warning

The example above assumes that the radius and area of a planet will not change
over time. This seems like a reasonable assumption but such an assumption is
not safe in every domain. If it was possible for one of the attributes to
change between method calls, memoizing that value could produce the wrong
result. Please keep this in mind when considering which methods to memoize.

Supported Ruby Versions
-----------------------

This library aims to support and is tested against the following Ruby versions:

* Ruby 3.2
* Ruby 3.3
* Ruby 3.4
* Ruby 4.0

If something doesn't work on one of these versions, it's a bug.

## Copyright

Copyright &copy; 2013-2026 Dan Kubb, Erik Berlin. See LICENSE for details.
