class Oo::Ir::Model::Data < Kangaroo::Base
  def self.get_object_reference idref
    idref = idref.split '.'
    database.execute self, 'get_object_reference', *idref
  end
  
  def self.get_object_by_reference idref
    type, id = get_object_reference idref
    
    Oo.class_for(type).find id
  end
end