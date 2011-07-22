module Kangaroo
  module Model
    module Associations
      module Many2one
        extend ActiveSupport::Concern
        
        def read_many2one_id_for field
          send(field.name).try :first
        end
        
        def write_many2one_id_for field, id
          send field.setter_name, id
        end
        
        def read_many2one_name_for field
          send(field.name).try :last
        end
        
        def read_many2one_obj_for field
          id = read_many2one_id_for(field)
          
          field.associated_model.find_by_id id
        end
        
        def write_many2one_obj_for field, obj
          write_many2one_id_for field, obj.id
        end
      end
    end
  end
end