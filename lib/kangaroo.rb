require 'kangaroo/railtie' if defined?(Rails)

require 'prettyprint'
require 'kangaroo/client'
require 'kangaroo/database_proxy'
require 'kangaroo/database'
require 'kangaroo/base'

require 'oo/ir/model'

module Kangaroo
  mattr_accessor :database
  
  def self.initialize config_file_or_hash
    configuration = if config_file_or_hash.is_a?(Hash)
      config_file_or_hash
    else
      YAML.load_file(config_file_or_hash)
    end
        
    base_client = Client.new configuration.slice("host", "port")
    
    base_client.common_service
    
    cfg = configuration["database"]
    
    self.database = base_client.database cfg["name"], cfg["user"], cfg["password"]
    
    self.database.load_models cfg['models'] || :all
  end
end