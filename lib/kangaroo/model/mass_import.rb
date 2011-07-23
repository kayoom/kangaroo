module Kangaroo
  module Model
    module MassImport
      extend ActiveSupport::Concern
      
      module ClassMethods
        def mass_import objects, options = {}
          batch_size = options[:batch_size]
          objects = objects.select { |o| self === o }
          
          if batch_size
            until objects.empty?
              batch_objects = objects.slice! 0, batch_size
              
              import_data *prepare_mass_import(batch_objects)
            end
          else
            import_data *prepare_mass_import(objects)
          end
        end
        
        protected
        def prepare_mass_import objects
          changed_fields = objects.sum [], &:changed
          changed_values = []
          
          changed_fields.uniq!
          objects.each do |object|
            attrs = object.instance_variable_get '@attributes'
            
            values = [object.id] + attrs.values_at(*changed_fields)
            changed_values << values
          end
          
          changed_fields = %w(.id) + changed_fields
          
          [changed_fields, changed_values]
        end
      end
    end
  end
end