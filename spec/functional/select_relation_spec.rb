require 'spec_helper'


module Kangaroo
  describe 'Select Relation' do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new('res.partner', config.database, 'SelectRelationSpec').load!
    end
    
    it 'adjusts "attribute_names" when record is fetched with select clause' do
      partner = SelectRelationSpec::Res::Partner.select(:lang, :email).first
      
      partner.attribute_names.should =~ %w(lang email)
      SelectRelationSpec::Res::Partner.attribute_names.count.should > 2
    end
    
    it 'returns only selected attributes' do
      partner = SelectRelationSpec::Res::Partner.select(:lang, :email).first
      
      partner.attributes.keys.should =~ %w(lang email)
    end
  end
end