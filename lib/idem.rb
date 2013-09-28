# encoding: utf-8

require 'thread_safe'

require 'idem/instance_methods'
require 'idem/module_methods'
require 'idem/memory'
require 'idem/version'

# Allow methods to be idempotent
module Idem

  # Default freezer
  Freezer = lambda { |object| object.freeze }.freeze

  # Hook called when module is included
  #
  # @param [Module] descendant
  #   the module or class including Idem
  #
  # @return [self]
  #
  # @api private
  def self.included(descendant)
    descendant.module_eval do
      extend ModuleMethods
      include InstanceMethods
    end
  end

end # Idem
