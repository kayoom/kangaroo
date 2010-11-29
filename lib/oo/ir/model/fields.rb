class Oo::Ir::Model::Fields < Kangaroo::Base
  self.column_names = %w(ttype relation relation_field readonly required model_id complete_name selection
                             select_level size model on_delete name field_description groups selectable
                             translate view_load state domain)
  define_attribute_methods *column_names
  
  def required?
    !!required
  end
  
  def readonly?
    !!readonly
  end
  
  def writeable?
    !readonly
  end
end
