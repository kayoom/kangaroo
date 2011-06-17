require 'spec_helper'

module Kangaroo
  describe Model::DynamicFinder do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new('res.country', config.database, 'DynamicFinderSpec').load!
    end
    
    after :each do
      @cleanup && @cleanup.call
    end
    
    it 'catches find_by_* calls' do
      DynamicFinderSpec::Res::Country.should respond_to :find_by_code
      DynamicFinderSpec::Res::Country.find_by_code('DE').code.should == 'DE'
    end
    
    it 'captches find_by_*_and_* calls' do
      DynamicFinderSpec::Res::Country.should respond_to :find_by_code_and_name
      DynamicFinderSpec::Res::Country.find_by_code_and_name('DE', 'Germany').name.should == 'Germany'
    end
    
    it 'Dynamic Finder can be used on relations' do
      DynamicFinderSpec::Res::Country.select(:code).find_by_code('DE').code.should == 'DE'
    end
    
    it 'catches find_all_by_* calls' do
      DynamicFinderSpec::Res::Country.find_all_by_code('DE').should be_an Array
      DynamicFinderSpec::Res::Country.find_all_by_code('DE').first.code.should == 'DE'
    end
  end
end