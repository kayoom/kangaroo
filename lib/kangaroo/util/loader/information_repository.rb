module Kangaroo
  module Util
    class Loader
      module InformationRepository
        def ir_module
          const_defined?("Ir") ?
          const_get("Ir") :
          define_ir_namespace
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
        
        def get_object_reference openerp_module, xml_id = nil
          openerp_module, xml_id = coerce_xml_id openerp_module, xml_id
          
          database.object('ir.model.data').get_object_reference openerp_module.to_s, xml_id.to_s
        end
        
        def by_xml_id openerp_module, xml_id = nil
          type, id = get_object_reference openerp_module, xml_id
          
          class_for(type).find id
        end
      
        private
        def coerce_xml_id openerp_module, xml_id = nil
          if xml_id.blank?
            openerp_module.split('.') 
          else
            [openerp_module, xml_id]
          end
        end
        
        def define_ir_namespace
          mod = Module.new
          mod.send :extend, Kangaroo::Util::Loader::Namespace
          const_set("Ir", mod)
        end
      end
    end
  end
end