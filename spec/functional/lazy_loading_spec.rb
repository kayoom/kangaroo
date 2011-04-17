require 'spec_helper'


module Kangaroo
  describe 'Lazy Loading' do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new('res.partner', config.database).load!
    end
    
    it 'raises an error if trying to access constant without corresponding OpenERP Model' do
      lambda {
        Oo::Abcd
      }.should raise_error
      
      lambda {
        Oo::Res::Bcde
      }.should raise_error
    end
    
    it 'lazy loads additional models in an OpenERP namespace' do
      lambda {
        Oo::Res::Country
      }.should_not raise_error
    end
    
    it 'creates namespace modules on demand' do
      lambda {
        Oo::Product
      }.should_not raise_error
    end
    
    it 'lazy loads missing models in other namespaces' do
      lambda {
        Oo::Product::Product
      }.should_not raise_error
    end
  end
end