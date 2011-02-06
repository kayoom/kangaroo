require 'kangaroo/ruby_adapter/class_definition'
require 'kangaroo/ruby_adapter/fields'
require 'kangaroo/ruby_adapter/associations'
require 'kangaroo/ruby_adapter/states'
require 'kangaroo/ruby_adapter/validations'

module Kangaroo
  module RubyAdapter
    class Base
      include ClassDefinition
      include Fields
      include Associations
      include States
      include Validations
      
      def initialize model
        @model = model
      end
      
      # Adapt the OpenERP model to ruby
      #
      # return [Class] A Kangaroo::Model::Base subclass representing the OpenERP model
      def to_ruby
        define_class
        add_fields
        add_associations
        add_state_machine
        add_validations
      end
    end
  end
end