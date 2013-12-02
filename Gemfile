# encoding: utf-8

source 'https://rubygems.org'

gemspec

gem 'rake'

group :test do
  gem 'coveralls', :require => false
  gem 'rspec',     '~> 2.14'
  gem 'simplecov', :require => false
end

platforms :ruby_18, :jruby do
  gem 'mime-types', '~> 1.25'
end

platforms :rbx do
  gem 'rubinius-coverage',  '~> 2.0'
  gem 'rubysl-coverage',    '~> 2.0'
  gem 'rubysl-singleton',   '~> 2.0'
  gem 'rubysl-prettyprint', '~> 2.0'
end
