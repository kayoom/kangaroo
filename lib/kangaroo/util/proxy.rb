require 'rapuncel'

module Kangaroo
  module Util
    class Proxy < Rapuncel::Proxy
      autoload :Common, 'kangaroo/util/proxy/common'
      autoload :Db, 'kangaroo/util/proxy/db'
      autoload :Superadmin, 'kangaroo/util/proxy/superadmin'
      autoload :Object, 'kangaroo/util/proxy/object'
      autoload :Workflow, 'kangaroo/util/proxy/workflow'
      autoload :Report, 'kangaroo/util/proxy/report'
      autoload :Wizard, 'kangaroo/util/proxy/wizard'

      def __initialize__ client, *curry_args
        super client, nil
        @curry_args = curry_args
      end
      
      def call! name, *args
        super name, __curry__(*args)
      end
      
      def self.new *args
        allocate.__tap__ do |proxy|
          proxy.__initialize__ *args
        end
      end
      
      protected
      def __curry__ *args
        @curry_args + args
      end
    end
  end
end