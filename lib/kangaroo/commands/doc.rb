require 'kangaroo/commands/base'
require 'kangaroo/commands/endpoint'
require 'kangaroo/doc'

module Kangaroo
  module Commands
    class Doc < Base
      def run
        super
        
        initialize_global_endpoint
        generate_yardoc
      end
      
      protected
      def set_load_associations
        @load_associations = true
      end
      
      def setup_options p
        super
        setup_option p, '--load_associations', 'Wether to load associated models too.'
      end
      
      def initialize_global_endpoint
        ::Kang.connect configuration, logger
        ::Kang.load_models!
        ::Kang.load_associated_models! if @load_associations
      end
      
      def generate_yardoc
        Kangaroo::Doc::Base.generate ::Kang.namespace
      end
      
      def banner
        "".tap do |s|
          s << 'kangdoc - Generate yardoc for OpenERP models.'
          s << ''
          s << 'Usage:'
        end
      end
    end
  end
end
