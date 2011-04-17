require 'kangaroo/model/base'

module Kangaroo
  module RubyAdapter
    module ClassDefinition
      def define_class
        initialize_namespace
        define_model_class
      end

      protected
      def model_subclass
        Class.new(Kangaroo::Model::Base)
      end

      def define_model_class
        @ruby_model = set_const_in @namespace, constant_names.last, model_subclass

        if !@ruby_model.is_a?(Class)
          raise ChildDefinedBeforeParentError
        end
        @ruby_model.database = @oo_model.class.database
        @ruby_model.namespace = @oo_model.class.namespace
        @ruby_model.oo_name = @oo_model.model
        @ruby_model
      end

      def initialize_namespace
        @namespace = @root_namespace

        constant_names[1..-2].each do |mod|
          const = Module.new
          const.send :extend, Util::Loader::Namespace
          @namespace = set_const_in @namespace, mod, const
        end
      end

      def constant_names
        @constant_names ||= @oo_model.model_class_name.split("::")
      end

      # Set constant only if not already defined
      def set_const_in mod, name, const
        mod.const_set name, const unless mod.const_defined?(name)
        mod.const_get name
      end
    end
  end
end
