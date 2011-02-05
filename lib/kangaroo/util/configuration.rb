require 'logger'
require 'kangaroo/util/client'

module Kangaroo
  module Util
    class Configuration
      attr_accessor :logger, :database, :models, :client
    
      def initialize config_file_or_hash
        case config_file_or_hash
        when String
          configure_by_file config_file_or_hash
        when Hash
          configure_by_hash config_file_or_hash
        end
      end
    
      def load_models
        if models.blank?
          logger.info "No models to load."
          return
        end
        
        login
        Loader.new(@database, models).load!
        logger.info "Loaded OpenERP models matching #{models.inspect}."
      rescue Exception => e
        logger.error "Loading of OpenERP models failed.\n#{e.inspect}"
      end
    
      def configure_by_file filename
        configure_by_hash YAML.load_file(filename)
      end
    
      def configure_by_hash config
        @logger = config['logger'] || Logger.new(STDOUT)
        @client = Client.new config.slice('host', 'port')
        configure_database config['database']
      end
    
      def configure_database db_config
        @database = Database.new @client, *db_config.values_at('name', 'user', 'password')
        @models =  db_config['models']
        logger.info %Q(Configured OpenERP database "#{db_config['name']}" at "#{db_config['host']}")
      end
      
      def login
        if @database.login
          logger.info %Q(Authenticated user "#{db_config['user']}" for OpenERP database "#{db_config['name']}")
        else
          logger.warn %Q(Login to OpenERP database "#{db_name}" with user "#{user}" failed!)
        end
      end
    end
  end
end