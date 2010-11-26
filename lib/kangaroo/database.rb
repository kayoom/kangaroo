module Kangaroo
  class Database
    attr_accessor :db_name, :user, :password, :user_id, :base_client
    
    def proxy
      @proxy ||= DatabaseProxy.new client, self
    end
    
    def client
      @client ||= base_client.object_service
    end
    
    def initialize base_client, name, user, user_id, password
      @base_client, @db_name, @user, @user_id, @password = base_client, name, user, user_id, password
    end
    
    def search model, conditions = []
      proxy.execute model.oo_model_name, 'search', conditions
    end    
    
    def read model, ids
      proxy.execute model.oo_model_name, 'read', ids
    end
    
    
  end
end