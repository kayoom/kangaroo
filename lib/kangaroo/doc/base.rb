require 'yard'

module Kangaroo
  module Doc
    class Base
      attr_accessor :logger
      
      def initialize object, logger
        @logger = logger
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
        def generate root_namespace, logger = Logger.new(STDOUT)
          RootNamespace.new(root_namespace, logger).register
          logger.info "Generating documentation ..."
          YARD::Templates::Engine.generate YARD::Registry.all(:root, :module, :class), yard_options(root_namespace)
          logger.info "Great success!"
        end
        
        protected
        def verifier
          YARD::Verifier.new("!object.tag(:private) && (object.namespace.is_a?(CodeObjects::Proxy) || !object.namespace.tag(:private))",
             "object.type != :method || [:public].include?(object.visibility)")
        end
        
        def yard_options root_namespace
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
            :title            => "OpenERP Database: #{root_namespace.reflection_model.database.db_name}"
          }
        end
      end
    end
  end
end