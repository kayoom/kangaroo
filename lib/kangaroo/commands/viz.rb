require 'kangaroo/commands/base'
require 'kangaroo/commands/endpoint'
require 'kangaroo/viz'

module Kangaroo
  module Commands
    class Viz < Base
      def run
        super
        
        initialize_global_endpoint
        init_viz.generate
      end
      
      protected
      def set_load_associations
        @load_associations = true
      end
      
      def set_file file
        @file = file
      end
      
      def set_type type
        @type = type
      end
      
      def setup_options p
        super
        setup_option p, '--load_associations', 'Wether to load associated models too.'
        setup_option p, "--type FILE", "Specify output type (e.g. png, pdf, svg, etc. see ruby-graphviz)"
        setup_option p, "--file TYPE", "Specify output file (e.g. kangaroo_models.png)"
      end
      
      def initialize_global_endpoint
        ::Kang.connect configuration, logger
        ::Kang.load_models!
        ::Kang.load_associated_models! if @load_associations
      end
      
      def init_viz
        Kangaroo::Viz::Base.new(::Kang.namespace).tap do |viz|
          viz.namespace.dont_load_models = !@load_associations
          viz.file = @file || "kangaroo_viz.png"
          viz.type = @type || "png"
        end
      end
      
      def banner
        "".tap do |s|
          s << 'kangviz - Generate graphviz for OpenERP models.'
          s << ''
          s << 'Usage:'
        end
      end
    end
  end
end
