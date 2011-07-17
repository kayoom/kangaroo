require 'yard'

module Kangaroo
  module Doc
    class Base
      def initialize object
        ivar_name = self.class.name.demodulize.underscore
        @object = object
        instance_variable_set "@#{ivar_name}", object
      end
      
      def register ; end
      
      protected
      def name
        @object.name
      end
      
      def register_with_yard type, name, root = YARD::Registry.root, &block
        obj = object_for_type(type).new root, name, &block
        YARD::Registry.register obj
        
        obj
      end
      
      def object_for_type type
        YARD::CodeObjects.const_get("#{type}_object".camelize)
      end
      
      class << self
        def generate root_namespace
          RootNamespace.new(root_namespace).register
          YARD::Templates::Engine.generate YARD::Registry.all(:root, :module, :class), yard_options
        end
        
        protected
        def verifier
          YARD::Verifier.new("!object.tag(:private) && (object.namespace.is_a?(CodeObjects::Proxy) || !object.namespace.tag(:private))",
             "object.type != :method || [:public].include?(object.visibility)")
        end
        
        def yard_options
          {
            :files            => [],
            :verifier         =>  verifier,
            :serializer       =>  YARD::Serializers::FileSystemSerializer.new,
            :default_return   => "Object",
            :format           => :html,
            :hide_void_return => false,
            :template         => :default,
            :no_highlight     => false,
            :markup           => :rdoc,
            :title            => "Documentation by YARD 0.7.2"
          }
        end
      end
    end
  end
end