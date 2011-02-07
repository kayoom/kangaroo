require 'spec_helper'
require 'server_helper'

require 'kangaroo/util/configuration'

module Kangaroo
  module Util
    describe Configuration do
      include TestServerHelper
      
      def config_file
        File.join File.dirname(__FILE__), '..', 'test_env', 'test.yml'
      end
      
      it "configures Kangaroo by config file" do
        config = Kangaroo::Util::Configuration.new(config_file, Logger.new('/dev/null'))
        
        config.models.should == ['res.*']
        config.database.db_name.should == 'kangaroo_test_database'
        config.database.user.should == 'admin'
        config.database.password.should == 'admin'
      end
      
      it 'authorizes the configured user before model loading' do
        config = Kangaroo::Util::Configuration.new(config_file, Logger.new('/dev/null'))
        loader = mock('loader')
        loader.stub! :load!
        Loader.stub!(:new).and_return loader
        
        common_service.should_receive(:xmlrpc_call).
                        with('login', 'kangaroo_test_database', 'admin', 'admin')
        config.load_models
      end
    end
  end
end
