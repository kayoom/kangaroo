module Kangaroo
  module Model
    module Associations
      module Many2one
        extend ActiveSupport::Concern
        
        def read_many2one_id_for field
          field_value = send field.name
          
          if Array === field_value
            field_value.first
          else
            field_value
          end
        end
        
        def write_many2one_id_for field, id
          send field.setter_name, id
        end
        
        def read_many2one_name_for field
          field_value = send field.name
          
          if Array === field_value
            field_value.last
          else
            read_many2one_obj_for(field).try :name
          end
        end
        
        def read_many2one_obj_for field
          id = read_many2one_id_for(field)
          
          field.relation_class.find_by_id id
        end
        
        def write_many2one_obj_for field, obj
          write_many2one_id_for field, obj.id
        end
      end
    end
  end
end