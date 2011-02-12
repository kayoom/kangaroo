module Kangaroo
  module Util
    class Loader
      module Model
        def self.included klass
          klass.class_attribute :column_names
          klass.column_names = %w(state osv_memory name model info field_id access_ids)
          klass.define_multiple_accessors *klass.column_names
        end

        def length_of_model_name
          model.length
        end

        def model_class_name
          self.class.namespace.oo_to_ruby model
        end
      end
    end
  end
end