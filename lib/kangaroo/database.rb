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
    
    %w(search read).each do |action|
      define_method action do |model, *args|
        proxy.execute model.oo_model_name, action, *args
      end
    end
    
    
    
  end
end