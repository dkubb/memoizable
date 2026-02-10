# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "memoizable/version"

Gem::Specification.new do |gem|
  gem.name = "memoizable"
  gem.version = Memoizable::VERSION
  gem.authors = ["Dan Kubb", "Erik Berlin"]
  gem.email = ["dan.kubb@gmail.com", "sferik@gmail.com"]
  gem.summary = "Memoize method return values"
  gem.description = gem.summary
  gem.homepage = "https://github.com/dkubb/memoizable"
  gem.license = "MIT"

  gem.required_ruby_version = ">= 3.2"

  gem.files = Dir["lib/**/*", "CHANGELOG.md", "CONTRIBUTING.md", "LICENSE.md", "README.md"]
  gem.require_paths = ["lib"]

  gem.metadata["homepage_uri"] = gem.homepage
  gem.metadata["source_code_uri"] = "https://github.com/dkubb/memoizable"
  gem.metadata["changelog_uri"] = "https://github.com/dkubb/memoizable/blob/main/CHANGELOG.md"
  gem.metadata["rubygems_mfa_required"] = "true"
end
