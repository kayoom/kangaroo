require 'spec_helper'
require 'server_helper'

require 'kangaroo/ruby_adapter/base'

module Kangaroo
  module RubyAdapter
    describe ClassDefinition do
      def stub_oo_model name
        eval('module ::Oo ; end')
        oo_model = mock 'oo_model'
        oo_model.stub_chain(:class, :namespace).and_return(Oo)
        oo_model.stub_chain(:class, :database)
        oo_model.stub!('model_class_name').and_return(name)
        oo_model
      end

      def adapt_oo_model name
        oo_model = stub_oo_model name
        adapter = Base.new(oo_model)
        adapter.send :define_class
      end

      it 'creates a class in Oo for a (theoretical) top-level OpenObject model' do
        ruby_model = adapt_oo_model 'Oo::User'

        ruby_model.name.should == 'Oo::User'
        ruby_model.superclass.should be(Kangaroo::Model::Base)
      end

      it 'creates module namespaces for nested OpenObject models' do
        ruby_model = adapt_oo_model 'Oo::A::B::User'

        ruby_model.name.should == 'Oo::A::B::User'
        Oo::A.should be_a(Module)
        Oo::A::B.should be_a(Module)
      end

      it 'nests models in classes if a parent model is already loaded' do
        parent_model = adapt_oo_model 'Oo::C::D'
        ruby_model = adapt_oo_model 'Oo::C::D::E'

        Oo::C::D.should be_a(Class)
        Oo::C::D::E.should be_a(Class)
      end

      it 'raises an error if trying to define a parent model after a child model' do
        child_model = adapt_oo_model 'Oo::Sale::Order::Line'

        lambda { adapt_oo_model('Oo::Sale::Order') }.should raise_error(Kangaroo::ChildDefinedBeforeParentError)
      end
    end
  end
end