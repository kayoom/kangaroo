require 'rapuncel'

module Kangaroo
  module Util
    class Proxy < Rapuncel::Proxy
      autoload :CommonProxy, 'kangaroo/util/proxy/common'
      autoload :DbProxy, 'kangaroo/util/proxy/db'
      autoload :SuperadminProxy, 'kangaroo/util/proxy/superadmin'
      autoload :ObjectProxy, 'kangaroo/util/proxy/object'
      autoload :WorkflowProxy, 'kangaroo/util/proxy/workflow'
      autoload :ReportProxy, 'kangaroo/util/proxy/report'

      def __initialize__ client, *curry_args
        @curry_args = curry_args
      end
      
      def call! name, *args
        super name, __curry__(*args)
      end
      
      protected
      def __curry__ *args
        curry_args + args
      end
    end
  end
end