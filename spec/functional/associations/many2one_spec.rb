require 'spec_helper'

module Kangaroo
  describe Model::Associations, 'Many2one' do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new(%w(res.partner res.partner.address), config.database, 'AssociationsSpec').load!
    end
    
    after :each do
      @cleanup && @cleanup.call
    end
    
    it 'reads id of associated object' do
      address = AssociationsSpec::Res::Partner::Address.find 1
      
      address.partner_id_id.should == 1
    end
    
    it 'reads name of of associated object' do
      address = AssociationsSpec::Res::Partner::Address.find 1
      
      address.partner_id_name.should be_a String
    end
    
    it 'writes id of object to associate' do
      @cleanup = lambda do
        address = AssociationsSpec::Res::Partner::Address.find 1
        address.partner_id = 1
        address.save!
      end
      
      address = AssociationsSpec::Res::Partner::Address.find 1
      address.partner_id_id = 2
      address.save!
      
      address = AssociationsSpec::Res::Partner::Address.find 1
      address.partner_id_id.should == 2
    end
    
    it 'reads associated object' do
      address = AssociationsSpec::Res::Partner::Address.find 1
      partner = AssociationsSpec::Res::Partner.find 1
      
      address.partner_id_id.should == 1
      address.partner_id_obj.should == partner
    end
    
    it 'writes association' do
      @cleanup = lambda do
        address = AssociationsSpec::Res::Partner::Address.find 1
        address.partner_id = 1
        address.save!
      end
      
      address = AssociationsSpec::Res::Partner::Address.find 1
      partner = AssociationsSpec::Res::Partner.find 2
      address.partner_id_obj = partner
      address.save!
      
      address = AssociationsSpec::Res::Partner::Address.find 1
      address.partner_id_id.should == 2
    end
  end
end