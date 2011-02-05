module Oo
  autoload :Ir, 'oo/ir'
  
  def self.oo_name_to_ruby oo_name
    self.name + "::" + oo_name.gsub('.','/').camelize
  end
  
  def self.ruby_name_to_oo ruby_name
     ruby_name.sub(self.name + "::",'').underscore.gsub '/', '.'
  end
end