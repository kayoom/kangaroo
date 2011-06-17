module Kangaroo
  module RubyAdapter
    module Many2one
      protected
      def add_many2one_association association_field
        define_many2one_id_accessor association_field
        define_many2one_name_accessor association_field
        define_many2one_obj_accessor association_field
      end
      
      def define_many2one_obj_accessor association_field
        define_method_in_model "#{association_field.name}_obj" do
          id = id_for_associated  association_field.name
          
          association_field.relation_class.find_by_id id
        end
        
        define_method_in_model "#{association_field.name}_obj=" do |obj|
          send "#{association_field.name}=", obj.id if obj.persisted?
        end
      end
      
      def define_many2one_name_accessor association_field
        define_method_in_model "#{association_field.name}_name" do
          name_for_associated association_field.name
        end
      end
      
      def define_many2one_id_accessor association_field
        define_method_in_model "#{association_field.name}_id" do
          id_for_associated association_field.name
        end
        
        define_method_in_model "#{association_field.name}_id=" do |id|
          send "#{association_field.name}=", id
        end
      end
    end
  end
end