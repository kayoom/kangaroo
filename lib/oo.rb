module Oo
  def self.oo_name_to_ruby oo_name
    self.name + "::" + oo_name.gsub('.','/').camelize
  end
  
  def self.class_for oo_name
    oo_name_to_ruby(oo_name).constantize
  end
  
  def self.ruby_name_to_oo ruby_name
     ruby_name.sub(self.name + "::",'').underscore.gsub '/', '.'
  end
  
  def self.const_missing const
    if Kangaroo.configured?
      Kangaroo.load
    end
    
    if const_defined?(const)
      return const_get(const)
    end
    
    if Kangaroo.loaded?
      models = const.to_s.underscore + ".*"
      Kangaroo.logger.info "Loading missing models #{models}."
      Kangaroo.database.load_models [models]
    end
    
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