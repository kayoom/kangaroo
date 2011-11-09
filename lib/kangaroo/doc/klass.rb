require 'kangaroo/doc/namespace'

YARD::Tags::Library.define_tag "Selection Values", :selection
YARD::Tags::Library.define_tag "Properties", :flags
YARD::Tags::Library.visible_tags << :selection << :flags

module Kangaroo
  module Doc
    class Klass < Namespace
      def register
        klass = register_with_yard 'class', name do |r|
          r.superclass = P('Kangaroo::Model::Base')
          r.add_file "#{@klass.database.db_name}/#{@klass.oo_name}"
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
            
            if field.selection?
              selection_values(field).each do |val|
                add_tag m, :selection, val
              end
            end
            
            flags(field).each do |flag|
              add_tag m, :flags, flag
            end
            
            m.source = render_source field
          end
        end
      end
      
      protected
      def render_source field
        keys = field.attributes.keys.sort_by(&:to_s)
        
        a = []
        len = 0
        keys.each do |key|
          val = field.send(key)
          
          if val.present? && key != 'namespace'
            len = key.to_s.length if len < key.to_s.length
            a << [key, val] 
          end
        end
        
        "".tap do |s|
          a.each do |kv|
            s << ":" << kv.first.to_s.ljust(len, " ") << " => " << kv.last.pretty_inspect
          end
        end
      end
      
      def flags field
        [].tap do |f|
          f << '*Required*: true' if field.required?
          f << '*Readonly*: true' if field.always_readonly?
          f << "*Max* *length*: #{field.size}" if field.char? && field.size
          f << "*Digits*: #{field.digits * '.'}" if field.float? && field.digits
          f << "*Functional*: true" if field.functional?
          f << "*Selectable*: true" if field.selectable?
          
          if field.association?
            f << "*Associated* *Model*: {#{field.associated_model}}"
          end
        end
      end
      
      def selection_values field
        field.selection.map do |key_value|
            key, value = *key_value
            "'#{key}' (#{value})"
        end
      end
      
      def add_uniq_tag obj, name, *args
        add_tag obj, name, *args unless obj.tags(name).present?
      end
      
      def add_tag obj, name, *args
        obj.docstring.add_tag YARD::Tags::Tag.new(name, *args)
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