lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'memoizable/version'

Gem::Specification.new do |spec|
  spec.add_development_dependency('bundler', '~> 1.3', '>= 1.3.5')
  spec.add_dependency('thread_safe', '~> 0.1.3')

  spec.authors       = ["Dan Kubb"]
  spec.description   = %q{Memoize method return values}
  spec.email         = ["dan.kubb@gmail.com"]
  spec.files         = %w[CONTRIBUTING.md LICENSE.md README.md Rakefile memoizable.gemspec]
  spec.files        += Dir.glob("lib/**/*.rb")
  spec.homepage      = 'https://github.com/dkubb/memoizable'
  spec.licenses      = %w[MIT]
  spec.name          = 'memoizable'
  spec.require_paths = %w[lib]
  spec.summary       = spec.description
  spec.version       = Memoizable::VERSION.dup
end
