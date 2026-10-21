# frozen_string_literal: true

unless defined?(Mutant)
  begin
    require "simplecov"

    SimpleCov.start("strict") { cover "lib/**/*.rb" }
  rescue LoadError
    warn "Warning: simplecov is not installed. Coverage analysis will be skipped."
  end
end

require "memoizable"
require "rspec"

# Require spec support files and shared behavior
Pathname.glob(Pathname(__dir__).join("{shared,support}", "**",
  "*.rb")).sort.each do |file|
  require file.sub_ext("").to_s
end
