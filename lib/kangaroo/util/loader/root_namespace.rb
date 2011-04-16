module Kangaroo
  module Util
    class Loader
      module RootNamespace
        def oo_to_ruby oo_name
          name + "::" + oo_name.gsub('.','/').camelize
        end

        def ruby_to_oo ruby_name
           ruby_name.sub(name + "::",'').underscore.gsub '/', '.'
        end
        
        def reflection_model
          const_get('Ir').const_get('Model')
        end
        
        def model_exists? name
          name = ruby_to_oo name
          reflection_model.where(:model => name).exists?
        end
        
        def models_in? name
          name = ruby_to_oo name
          
          reflection_model.where("model like #{name}.%").exists?
        end
        
        def load_model model_name
          model_name = ruby_to_oo model_name
          Loader.new([model_name], reflection_model.database, name).load!.first
        end
      end
    end
  end
end