require 'spec_helper'
require 'server_helper'

require 'kangaroo/util/proxy'

module Kangaroo
  module Util
    describe Proxy do
      include TestServerHelper
      
      def client
        Rapuncel::Client.new :host => '127.0.0.1', :port => 8069, :path => '/xmlrpc/object'
      end
      
      def common_client
        Rapuncel::Client.new :host => '127.0.0.1', :port => 8069, :path => '/xmlrpc/common'
      end
      
      it 'proxies method calls' do
        proxy = Proxy.new common_client
        
        common_service.should_receive(:xmlrpc_call).with('some_method')
        proxy.some_method
      end
      
      it 'curries predefined arguments' do
        proxy = Proxy.new common_client, 'a', 'b'
        
        common_service.should_receive(:xmlrpc_call).with('some_method', 'a', 'b', 'd')
        proxy.some_method 'd'
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
