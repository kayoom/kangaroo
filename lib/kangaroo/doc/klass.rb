require 'kangaroo/doc/namespace'

module Kangaroo
  module Doc
    class Klass < Namespace
      def register
        klass = register_with_yard 'class', name do |r|
          r.superclass = P('Kangaroo::Model::Base')
        end
        
        register_attributes_in klass
        logger.info "Read #{name}"
        register_namespaces_or_models
      end
      
      def register_attributes_in klass
        @klass.fields.sort_by{ |f| f.name.to_s }.each do |field|
          coerced_type = coerce_type(field)
          
          register_with_yard 'method', field.name, klass do |m|
            m.docstring.replace [field.string, field.help] * "\n\n"
            add_tag m, :return, field.name.to_s, coerced_type
            
            
            if field.type == 'selection'
              sel_values = field.selection.map do |key_value|
                key, value = *key_value
                "* '#{key}' (#{value})"
              end.join("\n")

              add_tag m, :note, "Possible values:\n#{sel_values}"
            end
          end
          
          # next if field.always_readonly?
          # register_with_yard 'method', "#{field.name}=", klass do |m|
          #   m.parameters << ["value"] if m.parameters.blank?
          #   m.docstring.replace [field.string, field.help] * "\n\n"
          #   add_tag m, :param, 'value', coerced_type
          #   add_tag m, :return, field.name.to_s, coerced_type
          # end
        end
      end
      
      protected
      def add_tag obj, name, *args
        obj.docstring.add_tag YARD::Tags::Tag.new(name, *args) if obj.tag(name).nil?
      end
      
      def coerce_type field
        case field.type
        when 'char', 'text'
          'String'
        when 'boolean'
          'Boolean'
        when 'integer'
          'Fixnum'
        when 'date', 'datetime', 'time'
          'Datetime'
        when 'float'
          'Float'
        else
          field.type
        end
      end
    end
  end
end