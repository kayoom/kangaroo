require 'spec_helper'
require 'server_helper'
require 'kangaroo/model/base'

module Kangaroo
  module Model
    describe OpenObjectOrm do
      include TestServerHelper
      
      before :each do
        @klass = Class.new(Kangaroo::Model::Base)
        @klass.define_multiple_accessors :a, :b
        @klass.stub!(:default_attributes).and_return({})
        @klass.stub!(:remote).and_return proxy('object', 'some_class')
      end
      
      describe '#search' do
        it 'delegates search calls with array conditions to object service' do
          object_service.should_receive(:xmlrpc_call).
                          with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, false
          @klass.search [['a', '=', 'one']]
        end
        
        it 'converts simple hash conditions' do
          object_service.should_receive(:xmlrpc_call).twice.
                          with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, false
          @klass.search [:a => 'one']
          @klass.search :a => 'one'
        end
        
        it 'converts array hash conditions' do
          object_service.should_receive(:xmlrpc_call).
                          with 'execute', 'some_class', 'search', [['a', 'in', ['one', 'two']]], 0, false
          @klass.search :a => ['one', 'two']
        end
        
        describe 'string conditions' do
          it 'parses equal to string condition' do
            object_service.should_receive(:xmlrpc_call).
                            with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, false
            @klass.search "a = one"
          end
          
          it 'parses not in condition' do
            object_service.should_receive(:xmlrpc_call).
                            with 'execute', 'some_class', 'search', [['a', 'not in', 'one']], 0, false
            @klass.search "a not in one"
          end
        end
      end
    end
  end
end