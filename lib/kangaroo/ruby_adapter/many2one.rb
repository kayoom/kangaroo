module Kangaroo
  module RubyAdapter
    module Many2one
      protected
      def add_many2one_association association_field
        define_many2one_id_accessor association_field
        define_many2one_name_accessor association_field
        define_many2one_obj_accessor association_field
      end
      
      def define_many2one_name_accessor association_field
        define_method_in_model "#{association_field.name}_name" do
          read_many2one_name_for association_field
        end
      end
      
      def define_many2one_id_accessor association_field
        define_method_in_model "#{association_field.name}_id" do
          read_many2one_id_for association_field
        end
        
        define_method_in_model "#{association_field.name}_id=" do |id|
          write_many2one_id_for association_field, id
        end
      end
      
      def define_many2one_obj_accessor association_field
        define_method_in_model "#{association_field.name}_obj" do
          read_many2one_obj_for association_field
        end
        
        define_method_in_model "#{association_field.name}_obj=" do |obj|
          write_many2one_obj_for association_field, obj
        end
      end
    end
  end
end