require 'kangaroo/railtie' if defined?(Rails)

require 'prettyprint'
require 'kangaroo/client'
require 'kangaroo/database_proxy'
require 'kangaroo/database'
require 'kangaroo/base'

require 'oo'

module Kangaroo
  mattr_accessor :database, :models, :status, :client
  mattr_writer :logger
  
  def self.logger
    @@logger ||= Logger.new STDOUT
  end
  
  def self.initialize config_file_or_hash, logger = Logger.new(STDOUT)
    self.logger = logger
    
    configure config_file_or_hash
    load
  end
  
  def self.load
    self.database.load_models models
    
    logger.info "Loaded OpenERP models matching #{models.inspect}."
    self.status = :loaded
  rescue Exception => e
    logger.error "Could not load OpenERP models."
  end
  
  def self.configure config_file_or_hash
    
    configuration = if config_file_or_hash.is_a?(Hash)
      config_file_or_hash
    else
      YAML.load_file(config_file_or_hash)
    end
        
    self.client = Client.new configuration.slice("host", "port")
    cfg = configuration["database"]    
    self.models = cfg['models'] || :all
    
    self.database = client.database cfg["name"], cfg["user"], cfg["password"]
    
    logger.info "Configured OpenERP database #{cfg['name']} at #{configuration['host']}, with user #{cfg['user']}."
    self.status = :configured
  end
  
  def self.loaded?
    status == :loaded
  end
  
  def self.configured?
    status == :configured
  end
end