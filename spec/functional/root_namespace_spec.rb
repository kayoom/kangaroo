require 'spec_helper'

module Kangaroo
  describe 'Root namespace' do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new('res.partner', config.database, 'RootNamespaceSpec').load!
    end
    
    it "gets objects by xml id" do
      country = RootNamespaceSpec.by_xml_id :base, :de
      
      country.should be_a(RootNamespaceSpec::Res::Country)
      country.code.should == 'DE'
    end
  end
end