module Oo
  module Ir
    class Model
      class Field < Kangaroo::Model::Base
        class << self
          def fields_for ir_model
            fields_get(ir_model).map do |field_attributes|
              instantiate field_attributes
            end
          end
          
          protected
          def fields_get ir_model
            database.object.execute ir_model.model, 'fields_get'
          end
        end
      end
    end
  end
end