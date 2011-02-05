require 'rapuncel'
require 'kangaroo/util/database'

module Kangaroo
  module Util
    class Client < Rapuncel::Client
      SERVICES = %w(db common object wizard report).freeze
      
      def initialize configuration
        super configuration.merge(:raise_on => :both)
      end
    
      def clone
        super.tap do |c|
          c.connection = connection.clone
        end
      end
      
      SERVICES.each do |name|
        class_eval <<-RUBY
          def #{name}_service
            @#{name}_service ||= clone.tap do |c|
              c.connection.path = '/xmlrpc/#{name}'
            end
          end
        RUBY
      end
      
      def superadmin super_password
        SuperadminProxy.new db_service, super_password
      end
        
      def common
        @common_proxy ||= Proxy::Common.new common_service
      end

      def db
        @db_proxy ||= Proxy::Db.new db_service
      end      
    end
  end
end