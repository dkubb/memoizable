# encoding: utf-8

source 'https://rubygems.org'

gemspec

group :test do
  gem 'rspec', '~> 3.8', '>= 3.8.0'

  if RUBY_ENGINE.eql?('ruby') && RUBY_VERSION >= '2.7'
    gem 'simplecov', '~> 0.22', '>= 0.22.0'
  end
end
