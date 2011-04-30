module Kangaroo
  module Util
    class Database
      attr_accessor :db_name, :user, :password, :user_id, :client

      # Initialize a new OpenERP database configuration
      #
      # @param client A {Kangaroo::Util::Client Client} instance
      # @param name Database name to configure
      # @param user Username
      # @param password Password
      def initialize client, name, user, password
        @client, @db_name, @user, @password = client, name, user, password
      end

      # Access to the {Kangaroo::Util::Proxy::Superadmin Superadmin Proxy}
      #
      # @param super_password superadmin password
      # @return [Kangaroo::Util::Proxy::Superadmin] superadmin service proxy
      def superadmin super_password
        client.superadmin super_password
      end

      # Access to the {Kangaroo::Util::Proxy::Db Database Proxy}
      #
      # @return [Kangaroo::Util::Proxy::Db] database service proxy
      def db
        client.db
      end

      # Access to the {Kangaroo::Util::Proxy::Common Common Proxy}
      #
      # @return [Kangaroo::Util::Proxy::Common] common service proxy
      def common
        client.common
      end

      # Access to the {Kangaroo::Util::Proxy::Workflow Workflow Proxy}
      #
      # @return [Kangaroo::Util::Proxy::Workflow] workflow service proxy
      def workflow
        @workflow_proxy ||= Proxy::Workflow.new client.object_service, db_name, user_id, password
      end

      # Access to the Kangaroo::Util::Proxy::Object
      #
      # @return [Kangaroo::Util::Proxy::Object] object service proxy
      def object model_name
        Proxy::Object.new client.object_service, db_name, user_id, password, model_name
      end

      # Access to the {Kangaroo::Util::Proxy::Wizard Wizard Proxy}
      #
      # @return [Kangaroo::Util::Proxy::Wizard] wizard service proxy
      def wizard
        @wizard_proxy ||= Proxy::Wizard.new client.wizard_service, db_name, user_id, password
      end

      # Access to the {Kangaroo::Util::Proxy::Report Report Proxy}
      #
      # @return [Kangaroo::Util::Proxy::Report] report service proxy
      def report
        @report_proxy ||= Proxy::Report.new client.report_service, db_name, user_id, password
      end

      # Test of the current user is logged in
      #
      # @return true/false
      def logged_in?
        !!user_id
      end

      # Login the current user
      #
      # @return true/false
      def login!
        @user_id = common.login db_name, user, password

        logged_in?
      end

      # Login the current user, unless logged in.
      #
      # @return true/false
      def login
        logged_in? || login!
      rescue
        false
      end
    end
  end
end