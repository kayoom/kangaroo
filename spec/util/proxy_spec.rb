require 'spec_helper'
require 'server_helper'

require 'kangaroo/util/proxy'

module Kangaroo
  module Util
    describe Proxy do
      include TestServerHelper
      
      it 'proxies method calls' do
        proxy = Proxy.new client('common')
        
        common_service.should_receive(:xmlrpc_call).with('some_method')
        proxy.some_method
      end
      
      it 'curries predefined arguments' do
        proxy = Proxy.new client('common'), 'a', 'b'
        
        common_service.should_receive(:xmlrpc_call).with('some_method', 'a', 'b', 'd')
        proxy.some_method 'd'
      end
      
      describe Proxy::Object do
        it 'sends method calls via #execute to object service' do
          proxy = Proxy::Object.new client('object'), 'model'
          
          object_service.should_receive(:xmlrpc_call).with('execute', 'model', 'some_method', 'a')
          proxy.some_method 'a'
        end
        
        it 'curries database authentication' do
          proxy = Proxy::Object.new client('object'), 'some_db', 'a_user', 'my_password', 'model'
          
          object_service.should_receive(:xmlrpc_call).with('execute', 'some_db', 'a_user', 'my_password', 
                                                            'model', 'some_method', 'a')
          proxy.some_method 'a'
        end
      end
      
      describe Proxy::Db do
        it 'sends method calls to db service' do
          proxy = Proxy::Db.new client('db')
          
          db_service.should_receive(:xmlrpc_call).with('list')
          proxy.list
        end
      end
      
      describe Proxy::Superadmin do
        it 'curries pre-set superadmin password on method calls' do
          proxy = Proxy::Superadmin.new client('db'), 'superpw'
          
          db_service.should_receive(:xmlrpc_call).with('rename', 'superpw', 'oldname', 'newname')
          proxy.rename 'oldname', 'newname'
        end
      end
    end
  end
end
