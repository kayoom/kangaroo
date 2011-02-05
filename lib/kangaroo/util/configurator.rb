require 'kangaroo/util/client'

module Kangaroo
  module Util
    class Configurator
      attr_accessor :logger, :database, :models, :configured, :client
      alias_method :configured?, :configured
    
      def initialize config_file_or_hash, options = {}
        options = {
          :logger       => Logger.new(STDOUT),
          :load_models  => true
        }.merge options
      
        case config_file_or_hash
        when String
          configure_by_file config_file_or_hash
        when Hash
          configure_by_hash config_file_or_hash
        end
      
        if configured? && options[:load_models]
          load_models
        end
      end
    
      def load_models
        if models.blank?
          logger.info "No models to load."
          return
        end
        
        Loader.new(models).load!
        logger.info "Loaded OpenERP models matching #{models.inspect}."
      rescue Exception => e
        logger.error "Loading of OpenERP models failed.\n#{e.inspect}"
      end
    
      def configure_by_file filename
        configure_by_hash YAML.load_file(filename)
      rescue Errno::ENOENT => e
        logger.error "Kangaroo config file #{filename} not found."
      end
    
      def configure_by_hash config
        @client = Client.new config.slice('host', 'port')
        configure_database config['database']
        @configured = true
      end
    
      def configure_database db_config
        @database = Database.new @client, *db_config.values_at('name', 'user', 'password')
        @models =  db_config['models']
        logger.info %Q(Configured OpenERP database "#{db_config['name']}" at "#{db_config['host']}")
        if @database.login
          logger.info %Q(Authenticated user "#{db_config['user']}" for OpenERP database "#{db_config['name']}")
        else
          logger.warn "Login to OpenERP database #{db_name} with user #{user} failed!"
        end
      end
    end
  end
end