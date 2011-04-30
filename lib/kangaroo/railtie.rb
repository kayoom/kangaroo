module Kangaroo
  class Railtie < Rails::Railtie
    attr_accessor :configuration
    
    # Get the client instance configured via config/kangaroo.yml
    #
    # @return [Kangaroo::Util::Client] client
    def client
      @configuration.try :client
    end
    
    initializer 'kangaroo.initialize' do
      begin
        config_file = File.join(Rails.root, %w(config kangaroo.yml))
        @configuration = Kangaroo::Util::Configuration.new config_file, Rails.logger
        @configuration.load_models
      rescue Errno::ECONNREFUSED => e
        Rails.logger.error "Could not connect to OpenERP XML-RPC Service."
      end
    end
  end
end