module Kangaroo
  class Database
    attr_accessor :db_name, :user, :password, :user_id, :base_client, :models
    
    def proxy
      @proxy ||= DatabaseProxy.new client, self
    end
    
    def client
      @client ||= base_client.object_service
    end
    
    def initialize base_client, name, user, password, user_id = nil
      @base_client, @db_name, @user, @user_id, @password = base_client, name, user, user_id, password
      
      @models = []
    end
    
    %w(search read write create default_get unlink).each do |action|
      define_method action do |model, *args|
        execute model, action, *args
      end
    end
    
    def execute model, action, *args
      proxy.execute model.oo_model_name, action, *args
    end
    
    def logged_in?
      !!user_id
    end
    
    def login!
      @user_id = base_client.common_service.call_to_ruby('login', db_name, user, password)
      
      true
    end
    
    def login
      login!      
    rescue
      Kangaroo.logger.warn "Login to OpenERP database #{db_name} with user #{user} failed!"
      false
    end
    
    def load_models model_names = :all
      logged_in? || login!
      
      model_names = if model_names == :all
        %w(%)
      else
        model_names.map do |m|
          m.gsub('*', '%')
        end
      end
      
      models_to_load = model_names.sum([]) do |m|
        Oo::Ir::Model.where("model ilike #{m}").all
      end
      
      models_to_load = models_to_load.sort_by do |m|
        m.model.length
      end      
      
      create_models models_to_load
    end
    
    protected
    def create_models models_to_load
      @models += models_to_load
      
      models_to_load.map do |model|
        model.create_class
      end      
    end
  end
end