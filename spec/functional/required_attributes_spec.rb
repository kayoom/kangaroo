require 'spec_helper'

module Kangaroo
  describe Model::RequiredAttributes do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new('res.country', config.database, 'RequiredAttributesSpec').load!
    end
    
    after :each do
      @cleanup && @cleanup.call
    end
    
    it 'validates required fields' do
      c = RequiredAttributesSpec::Res::Country.new :name => 'ABCXYZ'
      
      c.valid?.should_not == true
      c.errors.keys.should include :code
    end
    
    it 'refuses to save invalid records' do
      c = RequiredAttributesSpec::Res::Country.new :name => 'ABCXYZ'
      
      c.save.should_not == true
      
      lambda {
        c.save!
      }.should raise_error
    end
  end
end