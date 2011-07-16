module Kangaroo
  module Commands
    class Endpoint
      attr_reader :configuration, :config, :client, :logger
      
      delegate :common, :db, :superadmin, :to => :client
      delegate :database, :to => :config
      
      def connect configuration = {}, logger = Logger.new(STDOUT)
        @logger = logger
        @configuration = configuration
        @config = Kangaroo::Util::Configuration.new configuration, logger
        @client = config.client
      end
      
      def load_models!
        config.load_models
      end
    end
  end
end

::Kang = Kangaroo::Commands::Endpoint.new