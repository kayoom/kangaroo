require 'kangaroo/railtie' if defined?(Rails)

require 'prettyprint'
require 'kangaroo/client'
require 'kangaroo/database_proxy'
require 'kangaroo/database'
require 'kangaroo/base'

require 'oo/ir/model'

module Kangaroo
  mattr_accessor :databases, :default
  
  def self.initialize config_file_or_hash
    configuration = if config_file_or_hash.is_a?(Hash)
      config_file_or_hash
    else
      YAML.load_file(config_file_or_hash)
    end
        
    base_client = Client.new configuration.slice("host", "port")
    
    self.databases = {}
    configuration["databases"].each do |name, cfg|      
      db_name = cfg["db_name"] || name
      database = base_client.database db_name, cfg["user"], cfg["password"]
      
      database.load_models cfg['models'] || :all
      databases[name.to_sym] = database
      self.default = database if cfg["default"]
    end
    
    unless default
      self.default = databases.values.first
    end
  end
end