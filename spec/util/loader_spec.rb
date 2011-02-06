require 'spec_helper'
require 'server_helper'

require 'kangaroo/util/loader'

module Kangaroo
  module Util
    describe Loader do
      # include TestServerHelper
      
      def config_file
        File.join File.dirname(__FILE__), '..', 'test_env', 'test.yml'
      end
      
      it "replaces wildcards in model names" do
        loader = Loader.new ['res.*']
        
        loader.model_names.should == ['res.%']
      end
      
      it "uses global wildcard if model_names = :all" do
        loader = Loader.new :all
        
        loader.model_names.should == ['%']
      end
      
      it 'raises error if model_names = nil or empty' do
        lambda { Loader.new nil }.should raise_error
        lambda { Loader.new [] }.should raise_error
      end
      
      it 'loads matching models from OpenERP' do
        loader = Loader.new ['res.*']
        
        loaded_model = mock 'loaded_model'
        loaded_model.stub!('length_of_model_name').and_return(1)
        ruby_adapter = mock 'ruby_adapter'
        ruby_adapter.stub! 'to_ruby'
        RubyAdapter::Base.should_receive(:new).with(loaded_model).and_return(ruby_adapter)
        
        Oo::Ir::Model = mock 'model'
        relation = mock 'relation'
        relation.should_receive(:all).and_return([loaded_model])
        Oo::Ir::Model.should_receive(:where).with(/res\.%/).and_return(relation)
        
        loader.load!
      end
    end
  end
end
