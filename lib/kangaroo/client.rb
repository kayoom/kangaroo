module Kangaroo
  class Client < Rapuncel::Client
    DB_SERVICE_PATH = '/xmlrpc/db'
    COMMON_SERVICE_PATH = '/xmlrpc/common'
    OBJECT_SERVICE_PATH = '/xmlrpc/object'
    
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
    
    def object_service
      @object_service ||= clone.tap do |c|
        c.connection.path = OBJECT_SERVICE_PATH
      end
    end
    
    def database name, user, password, options = {}
      try_login = options[:login] || false
      
      db = Database.new self, name, user, password
      
      if try_login
        db.login || Kangaroo.logger.warn("OpenERP login failed.")
      end
      
      db
    end
  end
end