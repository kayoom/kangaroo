require 'spec_helper'

module Kangaroo
  describe 'Lazy Loading' do
    before :all do
      config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      config.login
  
      Kangaroo::Util::Loader.new('res.partner', config.database, 'LazyLoadSpec').load!
    end
    
    it 'raises an error if trying to access constant without corresponding OpenERP Model' do
      lambda {
        LazyLoadSpec::Abcd
      }.should raise_error
      
      lambda {
        LazyLoadSpec::Res::Bcde
      }.should raise_error
    end
    
    it 'lazy loads additional models in an OpenERP namespace' do
      lambda {
        LazyLoadSpec::Res::Country
      }.should_not raise_error
    end
    
    it 'creates namespace modules on demand' do
      lambda {
        LazyLoadSpec::Product
      }.should_not raise_error
    end
    
    it 'lazy loads missing models in other namespaces' do
      lambda {
        LazyLoadSpec::Product::Product
      }.should_not raise_error
    end
    
    it 'lazy loads nested models' do
      lambda {
        LazyLoadSpec::Sale::Order::Line
      }.should_not raise_error
      
      LazyLoadSpec::Sale::Order.should be_a(Class)
    end
  end
end