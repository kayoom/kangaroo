module Kangaroo
  module Util
    class Loader
      module Reflection
        
        # Return the Reflection model ('ir.model') for this namespace
        def reflection_model
          @reflection_model ||= begin
            ir_module.const_defined?("Model") ?
            ir_module.const_get("Model") :
            ir_module.const_set("Model", create_reflection_model)
          end
        end
        
        # Check if a model exists, accepts Ruby or OpenObject name parameter
        def model_exists? name
          name = ruby_to_oo name
          reflection_model.where(:model => name).exists?
        end
        
        # Check if there are (nested) models in a namespace e.g.
        #
        #   models.in?('product') #=> true
        #
        # as there is at least the OpenObject model 'product.product'
        def models_in? name
          name = ruby_to_oo name
          
          reflection_model.where("model like #{name}.%").exists?
        end
        
        # Load an additional model into the current namespace
        def load_model model_name
          existing_ruby_class = oo_to_ruby(model_name).constantize rescue nil
          return existing_ruby_class if existing_ruby_class
          
          model_name = ruby_to_oo model_name
          Loader.new([model_name], reflection_model.database, name).load!.first
        end
        
        # Return the model for a specified OpenObject model
        def class_for oo_name
          oo_to_ruby(oo_name).constantize
        end
      
        private
        def create_reflection_model
          Class.new(Kangaroo::Model::Base).tap do |model|
            model.oo_name = 'ir.model'
            model.database = database
            model.namespace = self
            model.send :include, Model
          end
        end
      end
    end
  end
end