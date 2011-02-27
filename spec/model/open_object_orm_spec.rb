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

      describe '#read' do
        it 'reads and instantiates records' do
          object_service.stub!(:xmlrpc_call).
            with('execute', 'some_class', 'read', [1], ['a', 'b']).
            and_return([{:a => 'one', :id => 1}])
          @klass.read([1], :fields => ['a', 'b']).first.a.should == 'one'
        end

        it 'passes on the "context"' do
          object_service.stub!(:xmlrpc_call).
            and_return([{:a => 'one', :id => 1}])
          @klass.read([1], :fields => ['a', 'b'], :context => {:lang => 'de'}).first.context[:lang].should == 'de'
        end

        it 'uses attribute_names as default value for field list' do
          object_service.should_receive(:xmlrpc_call).with('execute', 'some_class', 'read', [1], ['a', 'b']).
            and_return([{:a => 'one', :id => 1}])
          @klass.read([1])
        end
      end

      describe '#fields_get' do
        it 'fetches details about fields of this model' do
          object_service.should_receive(:xmlrpc_call).with('execute', 'some_class', 'fields_get', ['a'], {}).
            and_return({:a => {:type => "selection"}})
          @klass.fields_get(:fields => ['a']).first.read_attribute(:type).should == 'selection'
        end

        it 'stores the name in the Field model' do
          object_service.should_receive(:xmlrpc_call).with('execute', 'some_class', 'fields_get', ['a'], {}).
            and_return({:a => {:type => "selection"}})
          @klass.fields_get(:fields => ['a']).first.name.should == :a
        end

        it 'uses attribute_names as default value for field list' do
          object_service.should_receive(:xmlrpc_call).
            with('execute', 'some_class', 'fields_get', ['a', 'b'], {}).
            and_return({:a => {:type => 'selection'}})
          @klass.fields_get
        end
      end

      describe '#search' do
        it 'delegates search calls with array conditions to object service' do
          object_service.should_receive(:xmlrpc_call).
            with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, false, false, false, false
          @klass.search [['a', '=', 'one']]
        end

        it 'allows empty conditions' do
          object_service.should_receive(:xmlrpc_call).exactly(4).times.
            with 'execute', 'some_class', 'search', [], 0, false, false, false, false
          @klass.search []
          @klass.search ''
          @klass.search nil
          @klass.search({})
        end

        it 'converts simple hash conditions' do
          object_service.should_receive(:xmlrpc_call).twice.
            with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, false, false, false, false
          @klass.search [:a => 'one']
          @klass.search :a => 'one'
        end

        it 'converts array hash conditions' do
          object_service.should_receive(:xmlrpc_call).
            with 'execute', 'some_class', 'search', [['a', 'in', ['one', 'two']]], 0, false, false, false, false
          @klass.search :a => ['one', 'two']
        end

        describe 'string conditions' do
          it 'parses equal to string condition' do
            object_service.should_receive(:xmlrpc_call).
              with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, false, false, false, false
            @klass.search "a = one"
          end

          it 'parses "not in" condition' do
            object_service.should_receive(:xmlrpc_call).
              with 'execute', 'some_class', 'search', [['a', 'not in', 'one']], 0, false, false, false, false
            @klass.search "a not in one"
          end
        end

        it 'accepts a limit option' do
          object_service.should_receive(:xmlrpc_call).
            with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, 20, false, false, false
          @klass.search 'a = one', :limit => 20
        end

        it 'accepts a offset option' do
          object_service.should_receive(:xmlrpc_call).
            with 'execute', 'some_class', 'search', [['a', '=', 'one']], 10, false, false, false, false
          @klass.search 'a = one', :offset => 10
        end

        it 'accepts a context option' do
          object_service.should_receive(:xmlrpc_call).
            with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, false, false, {"a" => 'b'}, false
          @klass.search 'a = one', :context => {:a => 'b'}
        end

        it 'accepts an order option' do
          object_service.should_receive(:xmlrpc_call).
            with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, false, 'b', false, false
          @klass.search 'a = one', :order => 'b'
        end

        it 'accepts a count option' do
          object_service.should_receive(:xmlrpc_call).
            with 'execute', 'some_class', 'search', [['a', '=', 'one']], 0, false, false, false, true
          @klass.search 'a = one', :count => true
        end
      end
    end
  end
end