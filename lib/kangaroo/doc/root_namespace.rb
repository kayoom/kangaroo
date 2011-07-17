require 'kangaroo/doc/namespace'

module Kangaroo
  module Doc
    class RootNamespace < Namespace
      def register
        YARD.parse(loader_modules)
        
        root = register_with_yard 'module', name do |r|
          mixin = P('Kangaroo::Util::Loader::RootNamespace')
          r.mixins(:class).unshift(mixin) unless r.mixins(:class).include?(mixin)
        end
        
        register_namespaces_in
      end
      
      def register_namespaces_in
        @root_namespace.constants.each do |namespace|
          namespace_const = @root_namespace.const_get(namespace)
          Namespace.new(namespace_const, logger).register
        end
      end
    end
  end
end