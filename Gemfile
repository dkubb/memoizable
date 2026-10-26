# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :test do
  gem "mutant-rspec", ">= 0.14"
  gem "rake", ">= 13.3.1"
  gem "rspec", ">= 3.13.2"
  gem "rubocop", ">= 1.74"
  gem "rubocop-performance", ">= 1.24"
  gem "rubocop-rake", ">= 0.7"
  gem "rubocop-rspec", ">= 3.5"
  gem "simplecov", ">= 1"
  gem "standard", ">= 1.46"
  gem "standard-performance", ">= 1.7"
  gem "steep", ">= 1.9", platforms: :ruby
  gem "yard", ">= 0.9.38"
  gem "yardstick", ">= 0.9.9"
end

group :development do
  # Duel requires Ruby 3.4 or later
  gem "duel", ">= 0.1.1" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4")
  gem "stackprof", platforms: :mri
end
