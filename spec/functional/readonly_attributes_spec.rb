require 'spec_helper'

module Kangaroo
  module Model
    describe ReadonlyAttributes do
      before :all do
        config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
        config.login
  
        Kangaroo::Util::Loader.new('res.partner', config.database, 'ReadonlyAttributesSpec').load!
      end
      
      it 'raises error if trying to write readonly attributes' do
        sale_order = ReadonlyAttributesSpec.by_xml_id :sale, :order
        
        ReadonlyAttributesSpec::Sale::Order.fields_hash[:amount_untaxed].readonly?.should == true
        
        lambda {
          sale_order.amount_untaxed = 200
        }.should raise_error
      end
      
      it 'does not raise error if in state where writing is allowed' do
        sale_order = ReadonlyAttributesSpec.by_xml_id :sale, :order
        
        # Asserting the assumptions, in case OpenERPs demo data changes
        ReadonlyAttributesSpec::Sale::Order.fields_hash[:name].readonly?.should == true
        ReadonlyAttributesSpec::Sale::Order.fields_hash[:name].readonly_in?('draft').should == false
        sale_order.state.should == 'draft'
        
        lambda {
          sale_order.name = "abcd"
        }.should_not raise_error
      end
    end
  end
end