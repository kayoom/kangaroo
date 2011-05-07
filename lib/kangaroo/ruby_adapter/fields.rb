require 'kangaroo/ruby_adapter/many2one'

module Kangaroo
  module RubyAdapter
    module Fields
      include Many2one
      
      def add_fields
        @ruby_model.define_multiple_accessors *field_names
      end
      
      def add_associations
        @ruby_model.association_fields.each do |association_field|
          add_association association_field
        end
      end
      
      def add_association association_field
        case association_field.type
        when 'many2one'
          add_many2one_association association_field
        end
      end
      
      protected      
      def define_method_in_model name, &block
        @ruby_model.send :define_method, name, &block
      end
      
      def field_names
        fields.map(&:name) - [:id]
      end
      
      def fields
        @fields ||= @ruby_model.fields
      end
    end
  end
end