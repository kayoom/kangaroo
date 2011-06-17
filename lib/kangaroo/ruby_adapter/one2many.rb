module Kangaroo
  module RubyAdapter
    module One2many
      protected
      def add_one2many_association association_field
        define_one2many_id_accessor association_field
        # define_one2many_name_accessor association_field
        # define_one2many_obj_accessor association_field
      end
      
      # def define_one2many_obj_accessor association_field
      #   define_method_in_model "#{association_field.name}_obj" do
      #     id = id_for_associated  association_field.name
      #     
      #     association_field.relation_class.find_by_id id
      #   end
      #   
      #   define_method_in_model "#{association_field.name}_obj=" do |obj|
      #     send "#{association_field.name}=", obj.id if obj.persisted?
      #   end
      # end
      # 
      # def define_one2many_name_accessor association_field
      #   define_method_in_model "#{association_field.name}_name" do
      #     name_for_associated association_field.name
      #   end
      # end
      # 
      def define_one2many_id_accessor association_field
        define_method_in_model "#{association_field.name}_ids" do
          send association_field.name
        end
        
        define_method_in_model "#{association_field.name}_ids=" do |ids|
          send "#{association_field.name}=", [[6, 0, ids]]
        end
      end
    end
  end
end