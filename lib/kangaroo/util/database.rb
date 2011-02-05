
module Kangaroo
  module Util
    class Database
      attr_accessor :db_name, :user, :password, :user_id, :client, :models
    
      def initialize client, name, user, password, user_id = nil
        @client, @db_name, @user, @user_id, @password = client, name, user, user_id, password
      
        @models = []
      end
      
      delegate :db, :common, :to => :client
      
      def workflow
        @workflow_proxy ||= Proxy::Workflow.new client.object_service, db_name, user_id, password
      end
      
      def object
        @object_proxy ||= Proxy::Object.new client.object_service, db_name, user_id, password
      end
      
      def wizard
        @wizard_proxy ||= Proxy::Wizard.new client.wizard_service, db_name, user_id, password
      end
      
      def report
        @report_proxy ||= Proxy::Report.new client.report_service, db_name, user_id, password
      end
    
      def logged_in?
        !!user_id
      end
    
      def login!
        @user_id = common_proxy.login db_name, user, password
      
        true
      end
    
      def login
        login! unless logged_in?
      rescue
        false
      end
    end
  end
end