module Kangaroo
  module RubyAdapter
    module One2many
      protected
      def add_one2many_association association_field
        define_one2many_id_accessor association_field
        define_one2many_obj_accessor association_field
      end
      
      def define_one2many_id_accessor association_field
        define_method_in_model "#{association_field.name}_ids" do
          read_one2many_ids_for association_field
        end
        
        define_method_in_model "#{association_field.name}_ids=" do |ids|
          write_one2many_ids_for association_field, ids
        end
      end

      def define_one2many_obj_accessor association_field
        define_method_in_model "#{association_field.name}_objs" do
          read_one2many_objs_for association_field
        end
        
        define_method_in_model "#{association_field.name}_objs=" do |objs|
          write_one2many_objs_for association_field, objs
        end
      end
    end
  end
end