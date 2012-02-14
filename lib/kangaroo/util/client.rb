require 'bsonrpc'
require 'kangaroo/util/database'
require 'kangaroo/util/proxy'

module Kangaroo
  module Util
    # This is the central point to interact with OpenERP. You can configure your
    # connection via Kangaroo::Util::Configuration.
    #
    # @see Kangaroo::Util::Configuration
    # @see Kangaroo::Util::Database
    # @example Configure Kangaroo and get the client instance
    #     config = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'
    #     client = config.client
    #
    # @example Use non-database dependent services
    #     client.common
    #     client.db
    #     client.superadmin 'superadminpassword'
    #
    # @example Use database dependent services
    #     client.database.object 'product.product'
    #     client.database.wizard
    #     client.database.report
    #     client.database.workflow
    #
    # @example For convenience, the non-database dependent services are also available via database
    #     client.database.common
    #     client.database.db
    #     client.database.superadmin 'superadminpassword'
    #
    class Client < Bsonrpc::Client
      SERVICES = %w(db common object wizard report).freeze

      # Initialize a Kangaroo XMLRPC Client
      #
      # @param [Hash] configuration configuration Hash
      # @option configuration [String] 'host' Hostname or IP address
      # @option configuration [String, Number] 'port' Port
      def initialize configuration
        super
      end

      # Access the Kangaroo::Util::Proxy::Superadmin
      #
      # @param [String] super_password Superadmin password
      # @return [Kangaroo::Util::Proxy::Superadmin] Superadmin proxy
      def superadmin super_password
        Proxy::Superadmin.new self, super_password
      end

      # Access the Kangaroo::Util::Proxy::Common
      #
      # @return [Kangaroo::Util::Proxy::Common] Common proxy
      def common
        @common_proxy ||= Proxy::Common.new self
      end

      # Access the Kangaroo::Util::Proxy::Db
      #
      # @return [Kangaroo::Util::Proxy::Db] Db proxy
      def db
        @db_proxy ||= Proxy::Db.new self
      end
      
      def inspect
        "<#Kangaroo::Util::Client:0x#{hash.to_s(16)}>"
      end
    end
  end
end