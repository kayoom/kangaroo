module Kangaroo
  class Database
    attr_accessor :db_name, :user, :password, :user_id, :base_client
    
    def proxy
      @proxy ||= Proxy.new(client, self)
    end
    
    def client
      @client ||= base_client.object_service
    end
    
    def initialize base_client, name, user, user_id, password
      @base_client, @name, @user, @user_id, @password = base_client, name, user, user_id, password
    end
  end
end