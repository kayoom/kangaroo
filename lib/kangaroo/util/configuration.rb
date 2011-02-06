require 'logger'
require 'active_support/core_ext/hash'
require 'kangaroo/util/client'
require 'kangaroo/util/loader'

module Kangaroo
  module Util
    class Configuration
      attr_accessor :logger, :database, :models, :client
    
      # Initialize the Kangaroo configuration
      #
      # @param [Hash, String] config_file_or_hash Configuration filename or Hash
      # @param [Logger] logger logger instance
      def initialize config_file_or_hash, logger = Logger.new(STDOUT)
        @logger = logger
        case config_file_or_hash
        when String
          configure_by_file config_file_or_hash
        when Hash
          configure_by_hash config_file_or_hash
        end
      end
    
      # Load configured models with {Kangaroo::Util::Loader Loader}
      #
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
    
      # Configure Kangaroo by YAML file
      #
      # @param [String] filename Filename to load YAML configuration from
      def configure_by_file filename
        configure_by_hash YAML.load_file(filename)
      end
    
      # Configure Kangaroo by Hash
      #
      # @param [Hash] config configuration Hash
      # @option config [String] 'host' Hostname or IP address
      # @option config [String, Number] 'port' Port
      # @option config [Hash] 'database' Configuration for database
      def configure_by_hash config
        @client = Client.new config.slice('host', 'port')
        configure_database config['database']
      end
    
      # Configure an OpenERP database
      #
      # @param [Hash] db_config database configuration hash
      # @option db_config [String] 'name' Name of database
      # @option db_config [String] 'user' Username to use for authentication
      # @option db_config [String] 'password' Password for authentication
      # @option db_config [Enumerable] 'models' List of models(-patterns) to load
      def configure_database db_config
        @database = Database.new @client, *db_config.values_at('name', 'user', 'password')
        @models =  db_config['models']
        logger.info %Q(Configured OpenERP database "#{db_config['name']}" at "#{client.connection.host}")
      end
      
      # Login to the configured database
      #
      def login
        if @database.login
          logger.info %Q(Authenticated user "#{@database.user}" for OpenERP database "#{@database.db_name}")
        else
          logger.warn %Q(Login to OpenERP database "#{@database.db_name}" with user "#{@database.user}" failed!)
        end
      end
    end
  end
end