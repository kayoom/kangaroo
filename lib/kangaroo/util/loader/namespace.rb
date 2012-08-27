module Kangaroo
  module Util
    class Loader
      module Namespace
        attr_accessor :namespace

        def inspect
          "Module '#{name}' contains loaded OpenERP Models/Namespaces: #{constants.join(', ')}"
        end

        def namespace_name
          namespace.name
        end

        def const_missing const_name
          namespaced_const_name = "#{name}::#{const_name}"

          if namespace.model_exists?(namespaced_const_name)
            namespace.load_model(namespaced_const_name)
          elsif namespace.models_in?(namespaced_const_name)
            Module.new.tap do |mod|
              mod.send :extend, Namespace
              mod.namespace = self
              const_set const_name, mod
            end
          else
            super
          end
        rescue Exception => e
          super
        end
      end
    end
  end
end
