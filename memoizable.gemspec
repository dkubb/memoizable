# encoding: utf-8

require File.expand_path('../lib/memoizable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'memoizable'
  gem.version     = Memoizable::VERSION.dup
  gem.authors     = ['Dan Kubb', 'Erik Michaels-Ober']
  gem.email       = ['dan.kubb@gmail.com', 'sferik@gmail.com']
  gem.description = 'Memoize method return values'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/dkubb/memoizable'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = %w[CONTRIBUTING.md LICENSE.md README.md memoizable.gemspec] + Dir['lib/**/*.rb']
  gem.extra_rdoc_files = Dir['**/*.md']

  gem.required_ruby_version = '>= 2.1'
end
