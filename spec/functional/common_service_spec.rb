require 'spec_helper'

module Kangaroo
  describe 'Common service' do
    before :all do
      @config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      @config.login
  
      Kangaroo::Util::Loader.new('res.partner', @config.database, 'CommonServiceSpec').load!
    end
    
    it "can change log levels" do
      @config.client.common.set_loglevel('admin', :debug).should == true
      @config.client.common.set_loglevel 'admin', :error
    end
    
    it "can read number of sql queries executed" do
      @config.client.common.set_loglevel 'admin', :debug_sql
      
      CommonServiceSpec::Res::Partner.first
      @config.client.common.get_sqlcount('admin').should > 0
      @config.client.common.set_loglevel 'admin', :error
    end
  end
end