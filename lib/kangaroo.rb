require 'kangaroo/railtie' if defined?(Rails)

require 'kangaroo/client'
require 'kangaroo/proxy'
require 'kangaroo/database'
require 'kangaroo/base'

require 'oo/ir/model'

module Kangaroo
  Databases = {}
  
  def self.initialize config_file
    configuration = YAML.load_file(config_file)
        
    base_client = Client.new configuration.slice("host", "port")
    
    configuration["databases"].each do |name, cfg|      
      db_name = cfg["db_name"] || name
      Databases[name.to_sym] = base_client.database db_name, cfg["user"], cfg["password"]
    end
  end
end