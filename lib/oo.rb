module Oo
  def self.oo_name_to_ruby oo_name
    self.name + "::" + oo_name.gsub('.','/').camelize
  end
  
  def self.ruby_name_to_oo ruby_name
     ruby_name.sub(self.name + "::",'').underscore.gsub '/', '.'
  end
  
  def self.const_missing const
    models = const.underscore + ".*"
    
    Kangaroo.database.load_models [models]
    
    const_get(const) || super
  end
end

require 'oo/ir/model'
require 'oo/ir/model/fields'
require 'oo/ir/model/data'