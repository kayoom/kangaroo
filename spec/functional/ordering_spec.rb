require 'spec_helper'

module Kangaroo
  describe 'Ordering' do
    before :all do
      @config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
      @config.login
  
      Kangaroo::Util::Loader.new('res.partner', @config.database, 'OrderingSpec').load!
    end

    it 'can order by id descending' do
      partners = OrderingSpec::Res::Partner.order('id desc').select(:id).all
      
      partners[1..-1].each_with_index do |p, i|
        partners[i].id.should > p.id
      end
    end
    
    it 'can reverse queries with default ordering' do
      partners = OrderingSpec::Res::Partner.select(:id).all
      reversed_partners = OrderingSpec::Res::Partner.reverse.select(:id).all
      
      partners.should == reversed_partners.reverse
    end
    
    it 'can return last element' do
      last = OrderingSpec::Res::Partner.last
      
      last.should == OrderingSpec::Res::Partner.all.last
    end
  end
end