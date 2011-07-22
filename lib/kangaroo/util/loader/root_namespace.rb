module Kangaroo
  module Util
    class Loader
      module RootNamespace
        # Apply naming convention: convert OpenObject name (e.g. "product.product") to
        # Ruby class name, respecting current namespace (e.g. "Oo::Product::Product")
        def oo_to_ruby oo_name
          name + "::" + oo_name.gsub('.','/').camelize
        end

        # Apply naming convention: convert
        # Ruby class name, respecting current namespace (e.g. "Oo::Product::Product")
        # to OpenObject name (e.g. "product.product")
        def ruby_to_oo ruby_name
           ruby_name.to_s.sub(name + "::",'').underscore.gsub '/', '.'
        end
        
        def ir_module
          const_get('Ir')
        end
        
        # Return the Reflection model ('ir.model') for this namespace
        def reflection_model
          ir_module.const_get('Model')
        end
        
        def values_model
          ir_module.const_get('Values')
        end
        
        def ir_get key1, key2, model
          model = ruby_to_oo model
          results = values_model.remote.get key1, key2, [model]
          
          {}.tap do |hsh|
            results.each do |result|
              id, name, value = result
              hsh[name.to_sym] = value
            end
          end
        end
        
        # Check if a model exists, accepts Ruby or OpenObject name parameter
        def model_exists? name
          name = ruby_to_oo name
          reflection_model.where(:model => name).exists?
        end
        
        # Check if there are models in a namespace e.g.
        #
        #   models.in?('product') #=> true
        #
        # as there is at least the OpenObject model 'product.product'
        def models_in? name
          name = ruby_to_oo name
          
          reflection_model.where("model like #{name}.%").exists?
        end
        
        # Load a model into the current namespace
        def load_model model_name
          existing_ruby_class = oo_to_ruby(model_name).constantize rescue nil
          return existing_ruby_class if existing_ruby_class
          
          model_name = ruby_to_oo model_name
          Loader.new([model_name], reflection_model.database, name).load!.first
        end
        
        def class_for oo_name
          oo_to_ruby(oo_name).constantize
        end
        
        def by_xml_id openerp_module, xml_id = nil
          openerp_module, xml_id = openerp_module.split('.') if xml_id.blank?
          type, id = reflection_model.database.object('ir.model.data').get_object_reference openerp_module.to_s, xml_id.to_s
          
          class_for(type).find id
        end
      end
    end
  end
end