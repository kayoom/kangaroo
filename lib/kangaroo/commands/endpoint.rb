module Kangaroo
  module Commands
    class Endpoint
      attr_reader :configuration, :config, :client, :logger, :models
      
      delegate :common, :db, :superadmin, :to => :client
      delegate :database, :to => :config
      
      def connect configuration = {}, logger = Logger.new(STDOUT)
        @logger = logger
        @configuration = configuration
        @config = Kangaroo::Util::Configuration.new configuration, logger
        @client = config.client
      end
      
      def load_models!
        @models = config.load_models
      end
      
      def load_associated_models!
        @models.each do |m|
          m.fields.each &:associated_model
        end
      end
      
      def namespace
        Kernel.const_get config.namespace
      end
    end
  end
end

::Kang = Kangaroo::Commands::Endpoint.new