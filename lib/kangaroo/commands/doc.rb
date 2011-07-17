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
      def initialize_global_endpoint
        ::Kang.connect configuration, logger
        ::Kang.load_models!
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
