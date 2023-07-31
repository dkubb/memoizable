# encoding: utf-8

source 'https://rubygems.org'

gemspec

group :test do
  gem 'rspec',     '~> 3.8', '>= 3.8.0'
  gem 'yardstick', '~> 0.9', '>= 0.9.9'

  if RUBY_ENGINE.eql?('ruby') && RUBY_VERSION >= '2.7'
    gem 'mutant',       '~> 0.11', '>= 0.11.22'
    gem 'mutant-rspec', '~> 0.11', '>= 0.11.22'
    gem 'simplecov',    '~> 0.22', '>= 0.22.0'

    source 'https://oss:sxCL1o1navkPi2XnGB5WYBrhpY9iKIPL@gem.mutant.dev' do
      gem 'mutant-license'
    end
  end
end
