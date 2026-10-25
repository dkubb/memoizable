# frozen_string_literal: true

require "bundler/gem_tasks"
# Override release task to skip gem push (handled by GitHub Actions with attestations)
Rake::Task["release"].clear
desc "Build gem and create tag (gem push handled by CI)"
task release: %w[build release:guard_clean release:source_control_push]

require "rspec/core/rake_task"
require "rubocop/rake_task"
require "standard/rake"
require "yard"
require "yardstick/rake/measurement"
require "yardstick/rake/verify"
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)

YARD::Rake::YardocTask.new(:yard)

Yardstick::Rake::Measurement.new(:yardstick)

Yardstick::Rake::Verify.new(:verify_measurements) do |verify|
  verify.threshold = 100
end

desc "Run RuboCop and Standard Ruby"
task lint: %i[rubocop standard]

desc "Run RSpec"
task test: :spec

desc "Run Mutant"
task :mutant do
  if Process.respond_to?(:fork)
    sh "bundle exec mutant run"
  else
    warn "Mutant is disabled (requires fork)"
  end
end

STEEP_AVAILABLE = begin
  require "steep"
  true
rescue LoadError
  false
end

desc "Run Steep type checker"
task :steep do
  if STEEP_AVAILABLE
    sh "bundle exec steep check"
  else
    warn "Steep is disabled"
  end
end

desc "Generate and verify documentation"
task docs: %i[yard verify_measurements]

task default: %i[test lint mutant docs steep]

begin
  require "duel/rake_task"
  Duel::RakeTask.new
rescue LoadError
  # Duel requires Ruby 3.4 or later
end
