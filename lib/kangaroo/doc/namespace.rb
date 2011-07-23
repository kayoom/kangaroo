require 'kangaroo/doc/base'

module Kangaroo
  module Doc
    class Namespace < Base
      def register
        nspace = register_with_yard 'module', name do |r|
          mixin = P('Kangaroo::Util::Loader::Namespace')
          r.mixins(:class).unshift(mixin) unless r.mixins(:class).include?(mixin)
          r.add_file "(none)"
        end
        
        register_namespaces_or_models
      end
      
      def register_namespaces_or_models
        @object.constants.each do |obj_name|
          obj_const = @object.const_get obj_name
          
          if obj_const.is_a?(Class) && obj_const.included_modules.map(&:name).include?("Kangaroo::Model::Attributes")
            Klass.new(obj_const, logger).register
          elsif obj_const.is_a?(Module) && obj_const.included_modules.map(&:name).include?("Kangaroo::Util::Loader::Namespace")
            Namespace.new(obj_const, logger).register
          end
        end
      end
      
      protected
      def loader_modules
        dir = File.expand_path "../../util/loader", __FILE__
        
        [
          File.join(dir, 'model.rb'),
          File.join(dir, 'namespace.rb'),
          File.join(dir, 'root_namespace.rb')
        ]
      end
    end
  end
end