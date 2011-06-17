require 'kangaroo/ruby_adapter/class_definition'
require 'kangaroo/ruby_adapter/fields'

module Kangaroo
  module RubyAdapter
    class Base
      include ClassDefinition
      include Fields
      
      attr_accessor :oo_model, :root_namespace

      def initialize model
        @oo_model = model
        @root_namespace = model.class.namespace
      end

      # Adapt the OpenERP model to ruby
      #
      # return [Class] A Kangaroo::Model::Base subclass representing the OpenERP model
      def to_ruby
        define_class
        add_fields
        add_associations
        
        @ruby_model
      end
    end
  end
end