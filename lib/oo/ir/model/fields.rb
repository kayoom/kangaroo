class Oo::Ir::Model::Fields < Kangaroo::Base
  define_attribute_methods :ttype, :relation, :relation_field, :readonly, :required, :model_id, :complete_name, :selection, 
                            :select_level, :size, :model, :on_delete, :name, :field_description, :groups, :selectable,
                            :translate, :view_load, :state, :domain
                            
  def model
    @model ||= Model.read Array(model_id).first
  end
end
