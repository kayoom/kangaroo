module Kangaroo
  module Model
    module ReadonlyAttributes
      
      def define_setter attribute_name
        field = fields_hash[attribute_name.to_sym] rescue nil
        
        super and return unless field
        return if field.always_readonly?
        
        unless field.eventually_readonly?
          super
        else
          define_method "#{attribute_name}=" do |value|
            if state.blank? && field.readonly?
              raise Kangaroo::ReadonlyRecord
            elsif field.readonly_in? state
              raise Kangaroo::ReadonlyRecord
            else
              write_attribute attribute_name, value
            end
          end
        end
      end
      
      
      protected
      def attributes_for_update
        without_readonly_attributes super
      end

      def attributes_for_create
        without_readonly_attributes super
      end
      
      def without_readonly_attributes attributes
        attributes.reject do |key, val|
          state && fields_hash[key.to_sym].readonly_in?(state)
        end
      end
    end
  end
end