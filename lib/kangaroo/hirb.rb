require 'hirb'

module Hirb::Views::Kangaroo
  def kangaroo__model__base_view obj
    { :fields => get_kangaroo_fields(obj) }
  end
  
  def get_kangaroo_fields obj
    fields = obj.class.attribute_names
    
    # if query used select
    if obj.attributes.keys.sort != obj.class.attribute_names.sort
      selected_columns = obj.attributes.keys
      sorted_columns = obj.class.attribute_names.dup.delete_if {|e| !selected_columns.include?(e) }
      sorted_columns += (selected_columns - sorted_columns)
      fields = sorted_columns.map {|e| e.to_sym}
    end
    fields
  end
end

Hirb::DynamicView.add Hirb::Views::Kangaroo, :helper => :auto_table