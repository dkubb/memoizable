# encoding: utf-8

begin
  require 'simplecov'

  SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter]

  SimpleCov.start do
    add_filter '/config'
    add_filter '/spec'
    add_filter '/vendor'
    command_name 'spec'
    minimum_coverage 100
  end
rescue LoadError
  $stderr.puts 'Warning: simplecov is not installed. Coverage analysis will be skipped.'
end

require 'memoizable'
require 'rspec'

# Require spec support files and shared behavior
Pathname.glob(Pathname(__dir__).join('{shared,support}', '**', '*.rb')).sort.each do |file|
  require file.sub_ext('').to_s
end

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.expect_with :rspec do |expect_with|
    expect_with.syntax = :expect
  end
end
