require 'spec_helper'
require 'server_helper'

require 'kangaroo/util/configuration'

module Kangaroo
  module Util
    describe Configuration do
      include TestServerHelper
      
      def config_file
        File.join File.dirname(__FILE__), 'test_env', 'test.yml'
      end
      
      it "configures Kangaroo by config file" do
        config = Kangaroo::Util::Configuration.new(config_file)
        
        config.models.should be(['res.*'])
        config.database.db_name.should be('kangaroo_test_database')
      end
    end
  end
end
