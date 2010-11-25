module Kangaroo
  class Proxy < Rapuncel::Proxy
    attr_accessor :db_name, :user_id, :password
    
    def __initialize__ client, database
      super client
      
      @db_name, @user_id, @password = database.db_name, database.user_id, database.password
    end
    
    def call! name, *args
      args = [@db_name, @user_id, @password] + args
      
      super name, *args
    end
  end
end