require 'spec_helper'

module Kangaroo
  describe 'Root namespace' do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new('res.partner', config.database, 'XmlIdSpec').load!
    end
    
    it "gets objects by xml id" do
      country = XmlIdSpec.by_xml_id :base, :de
      
      country.code.should == 'DE'
    end
  end
end