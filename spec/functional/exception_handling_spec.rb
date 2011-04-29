require 'spec_helper'

module Kangaroo
  describe 'Exception handling' do
    before :all do
      @config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      @config.login
  
      Kangaroo::Util::Loader.new('res.partner', @config.database, 'ExceptionHandlingSpec').load!
    end
    
    it "catches missing methods" do
      lambda {
        @config.client.common.abcdef
      }.should raise_error(NoMethodError)
    end
  end
end