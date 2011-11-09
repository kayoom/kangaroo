require 'graphviz'
require 'ruby-debug'

module Kangaroo
  module Viz
    class Base
      attr_accessor :namespace, :models, :file, :type
      
      def initialize namespace
        @namespace = namespace
        @models = models_in namespace
      end
      
      def generate
        @graph = GraphViz.new :G
        
        @models.each do |model|
          @graph.add_node model.name, node_opts_for(model)
        end
        
        @namespace.dont_load_models = true
        @models.each do |model|
          model.fields.each do |field|
            next unless field.association?
         
            @graph.add_edge model.name, field.relation_class.name, edge_opts_for(field) if field.relation_class
          end
        end
        
        @graph.output type.to_sym => file
      end
      
      def models_in namespace
        models = []
        
        namespace.constants.each do |const_name|
          const = namespace.const_get const_name
          models << const if is_a_model?(const)
          models += models_in(const) if is_a_namespace?(const) || is_a_model?(const)
        end
        
        models
      end
      
      protected
      def node_opts_for model
        {
          :label => "#{model.name}\n#{model.oo_name}"
        }
      end
      
      def edge_opts_for field
        color = color_for_association(field)
        
        {
          :label => label_for_association(field),
          :color => color,
          :fontcolor => color,
          :fontsize => 10
        }
      end
      
      def label_for_association field
        type = case field.type
        when 'one2many'   then '1..N'
        when 'many2one'   then 'N..1'
        when 'one2one'    then '1..1'
        when 'many2many'  then 'N..N'
        end
        
        "#{type}\n#{field.name}"
      end
      
      def color_for_association field
        case field.type
        when 'one2many'   then 'green'
        when 'many2one'   then 'blue'
        when 'one2one'    then 'red'
        when 'many2many'  then 'orange'
        end
      end
      
      def is_a_model? const
        const.is_a?(Class) && const.superclass == Kangaroo::Model::Base
      end
      
      def is_a_namespace? const
        const.is_a?(Module) && const.respond_to?(:namespace)
      end
    end
  end
end