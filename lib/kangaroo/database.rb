module Kangaroo
  class Database
    attr_accessor :db_name, :user, :password, :user_id, :base_client, :models
    
    def proxy
      @proxy ||= DatabaseProxy.new client, self
    end
    
    def client
      @client ||= base_client.object_service
    end
    
    def initialize base_client, name, user, user_id, password
      @base_client, @db_name, @user, @user_id, @password = base_client, name, user, user_id, password
    end
    
    %w(search read write).each do |action|
      define_method action do |model, *args|
        proxy.execute model.oo_model_name, action, *args
      end
    end
    
    def load_models model_names = :all
      model_names = if model_names == :all
        %w(%)
      else
        model_names.map do |m|
          m.gsub('*', '%')
        end
      end
      
      
      @models = model_names.sum([]) do |m|
        Oo::Ir::Model.using(self).where("model ilike #{m}").all
      end
      
      @models = @models.sort_by do |m|
        m.model.length
      end
      
      
      create_models
    end
    
    def create_models      
      @models.map do |model|
        model.create_class
      end      
    end
  end
end