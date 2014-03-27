# encoding: utf-8

source 'https://rubygems.org'

gemspec

gem 'rake'

group :test do
  gem 'coveralls', '~> 0.7.0', :require => false
  gem 'rspec',     '~> 2.14'
  gem 'simplecov', '~> 0.8.2', :require => false
end

platforms :ruby_18, :jruby do
  gem 'mime-types', '~> 2.2'
end
