require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  command_name 'spec'

  add_filter 'config'
  add_filter 'spec'
  add_filter 'vendor'

  minimum_coverage 89.8
end

require 'memoizable'
require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expect_with|
    expect_with.syntax = :expect
  end
end
