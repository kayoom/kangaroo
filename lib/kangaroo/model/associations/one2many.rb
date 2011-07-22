module Kangaroo
  module Model
    module Associations
      module One2many
        extend ActiveSupport::Concern
        
        def read_one2many_ids_for field
          field_value = send field.name
          return unless Array === field_value
          
          if Array === field_value.first
            field_value.first.last
          else
            field_value
          end
        end
        
        def write_one2many_ids_for field, ids
          send field.setter_name, coerce_one2many_ids(ids)
        end
        
        def read_one2many_objs_for field
          ids = read_one2many_ids_for field
          
          field.relation_class.where(:id => ids)
        end
        
        def write_one2many_objs_for field, objs
          ids = objs.map &:id
          
          write_one2many_ids_for field, ids
        end
        
        protected
        def coerce_one2many_ids ids
          [[6, 0, ids]]
        end
      end
    end
  end
end