module Oo
  module Ir
    class Model < Kangaroo::Model::Base
      autoload :Field, 'oo/ir/model/field'
      
      NAMESPACE = /^(.*)\.[^\.]+$/
      
      def self.column_names
        %w(state osv_memory name model info field_id access_ids)
      end
      
      define_attribute_methods *column_names
      
      def fields
        @fields ||= Field.fields_for self
      end
      
      def length_of_model_name
        model.length
      end
      
      def model_class
        @model_class ||= model_class_name.constantize
      end
      
      def model_class_name
        Oo.oo_name_to_ruby model
      end
    end
  end
end