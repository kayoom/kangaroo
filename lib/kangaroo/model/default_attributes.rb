module Kangaroo
  module Model
    module DefaultAttributes
      extend ActiveSupport::Concern
      
      included do
        before_initialize do
          return true if persisted?
          
          default_attributes = self.class.default_attributes
          if default_attributes.blank?
            return true
          end

          default_attributes.each do |name, value|
            write_attribute name, value
          end
        end        
      end

      module ClassMethods
        def default_attributes
          default_get :fields => attribute_names
        end
      end
    end
  end
end