module Oo
  module Ir
    class Model < Kangaroo::Model::Base
      def self.column_names
        %w(state osv_memory name model info field_id access_ids)
      end
      define_multiple_attributes *column_names
      
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