module Oo
  def self.oo_name_to_ruby oo_name
    self.name + "::" + oo_name.gsub('.','/').camelize
  end
  
  def self.ruby_name_to_oo ruby_name
     ruby_name.sub(self.name + "::",'').underscore.gsub '/', '.'
  end
  
  def self.const_missing const
    models = const.to_s.underscore + ".*"
    
    Kangaroo.database.load_models [models]
    
    if const_defined?(const)
      const_get(const)
    else
      super
    end
  end
end

require 'oo/ir/model'
require 'oo/ir/model/fields'
require 'oo/ir/model/data'