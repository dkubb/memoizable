# encoding: utf-8

source 'https://rubygems.org'

gemspec

gem 'rake', '~> 10.1'

group :test do
  gem 'coveralls', '~> 0.7.0'
  gem 'rspec',     '~> 2.14'
  gem 'simplecov', '~> 0.9.0'
end

platforms :ruby_18, :jruby do
  gem 'mime-types',  '~> 1.25'
  gem 'rest-client', '~> 1.6.8'
end
