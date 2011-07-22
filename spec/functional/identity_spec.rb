require 'spec_helper'

module Kangaroo
  describe 'Identity' do
    before :all do
      @config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      @config.login
  
      Kangaroo::Util::Loader.new('res.partner', @config.database, 'IdentitySpec').load!
    end

    it ': Instances of same OpenERP object are considered equal' do
      a = IdentitySpec::Res::Partner.first
      b = IdentitySpec::Res::Partner.first
      
      a.should == b
    end
    
    it ': Instances of different OpenERP objects are not equal' do
      a, b = IdentitySpec::Res::Partner.all[0, 2]
      
      a.should_not == b
    end
    
    it ': New records are not equal to anything' do
      a = IdentitySpec::Res::Partner.first
      b = IdentitySpec::Res::Partner.new
      c = IdentitySpec::Res::Partner.new
      
      a.should_not == b
      b.should_not == c
    end
    
    it ': Instances of different models are always not equal' do
      a = IdentitySpec::Res::Partner.find 1
      b = IdentitySpec::Res::Country.find 1
      
      a.should_not == b
    end
    
    it ': Arrays of same instances should be equal' do
      a = IdentitySpec::Res::Partner.first
      b = IdentitySpec::Res::Partner.first
      
      [a].should == [b]
    end
  end
end