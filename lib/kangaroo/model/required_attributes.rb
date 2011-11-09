module Kangaroo
  module Model
    module RequiredAttributes
      extend ActiveSupport::Concern
      include ActiveModel::Validations
      
      def save options = {}
        if options[:validate] != false
          valid? && super
        else
          super
        end
      end
      
      module ClassMethods
        def define_setter attribute_name
          if fields_hash[attribute_name.to_sym].try :required?
            validates_presence_of attribute_name
          end
        
          super
        end
      end
    end
  end
end