module Kangaroo
  class Client < Rapuncel::Client
    DB_SERVICE_PATH = '/xmlrpc/db'
    COMMON_SERVICE_PATH = '/xmlrpc/common'
    
    def clone
      super.tap do |c|
        c.connection = connection.clone
      end
    end
    
    def db_service
      @db_service ||= clone.tap do |c|
        c.connection.path = DB_SERVICE_PATH
      end
    end
    
    def common_service
      @common_service ||= clone.tap do |c|
        c.connection.path = COMMON_SERVICE_PATH
      end      
    end
    
    def database name, user, password
      if user_id = common_service.call_to_ruby('login', name, user, password)
        Database.new self, name, user, user_id, password
      else
        nil
      end
    end
  end
end