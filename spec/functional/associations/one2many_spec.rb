require 'spec_helper'

module Kangaroo
  describe Model::Associations, 'One2many' do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new(%w(res.partner res.partner.address), config.database, 'AssociationsSpec').load!
    end
    
    after :each do
      @cleanup && @cleanup.call
    end
    
    it 'reads ids of associated objects' do
      partner = AssociationsSpec::Res::Partner.find 1
      
      partner.address_ids.should == [1]
    end
    
    it 'reads ids of associate objects after change' do
      partner = AssociationsSpec::Res::Partner.find 1
      
      partner.address_ids = [2]
      partner.address_ids.should == [2]
    end
    
    it 'writes ids of objects to associate' do
      @cleanup = lambda do
        partner = AssociationsSpec::Res::Partner.find 1
        partner.address = [[6, 0, [1]]]
        partner.save!
      end
      
      partner = AssociationsSpec::Res::Partner.find 1
      partner.address_ids = [2]
      partner.save!
      
      partner = AssociationsSpec::Res::Partner.find 1
      partner.address.should == [2]
    end
    
    it 'reads associated objects' do
      partner = AssociationsSpec::Res::Partner.find 1
      address = AssociationsSpec::Res::Partner::Address.find 1
      
      partner.address_objs.should be_an Array
      partner.address_objs.to_a.should == [address]
    end
    
    it 'writes association' do
      @cleanup = lambda do
        address = AssociationsSpec::Res::Partner::Address.find 1
        address.partner_id = 1
        address.save!
      end
      
      address = AssociationsSpec::Res::Partner::Address.find 1
      partner = AssociationsSpec::Res::Partner.find 2

      partner.address_objs = [address]
    end
  end
end