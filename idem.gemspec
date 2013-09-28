# encoding: utf-8

require File.expand_path('../lib/idem/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'idem'
  gem.version     = Idem::VERSION.dup
  gem.authors     = ['Dan Kubb']
  gem.email       = 'dan.kubb@gmail.com'
  gem.description = 'Memoize method return values'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/dkubb/idem'
  gem.licenses    = %w[MIT]

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec/{unit,integration}`.split($/)
  gem.extra_rdoc_files = %w[LICENSE README.md CONTRIBUTING.md TODO]

  gem.add_runtime_dependency('thread_safe', '~> 0.1.3')

  gem.add_development_dependency('bundler', '~> 1.3', '>= 1.3.5')
end
