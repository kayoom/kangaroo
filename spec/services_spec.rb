require 'spec_helper'
require 'server_helper'

require 'kangaroo/util/proxy'

require 'ruby-debug'
module Kangaroo
  module Util
    describe Proxy do
      before :all do
        @test_server = TestServer.start
      end
      
      after :all do
        @test_server.stop
      end
      
      def object_service
        @test_server.object_service
      end
      
      def client
        Rapuncel::Client.new :host => '127.0.0.1', :port => 8069, :path => '/xmlrpc/object'
      end
      
      it 'curries predefined arguments' do
        proxy = Proxy.new client, 'a', 'b'
        
        object_service.should_receive(:xmlrpc_call).with('execute', 'a', 'b', 'c')
        proxy.execute 'c'
      end
      
      describe Object do
        it 'sends method calls via #execute' do
          proxy = Proxy::Object.new client
          
          object_service.should_receive(:xmlrpc_call).with('execute', 'model', 'some_method', 'a')
          proxy.some_method 'model', 'a'
        end
        
        it 'curries database authentication' do
          proxy = Proxy::Object.new client, 'some_db', 'a_user', 'my_password'
          
          object_service.should_receive(:xmlrpc_call).with('execute', 'some_db', 'a_user', 'my_password', 
                                                            'model', 'some_method', 'a')
          proxy.some_method 'model', 'a'
        end
      end
    end
  end
end
