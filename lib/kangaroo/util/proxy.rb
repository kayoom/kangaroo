require 'active_support/basic_object'

module Kangaroo
  module Util
    class Proxy < ActiveSupport::BasicObject
      autoload :Common, 'kangaroo/util/proxy/common'
      autoload :Db, 'kangaroo/util/proxy/db'
      autoload :Superadmin, 'kangaroo/util/proxy/superadmin'
      autoload :Object, 'kangaroo/util/proxy/object'
      autoload :Workflow, 'kangaroo/util/proxy/workflow'
      autoload :Report, 'kangaroo/util/proxy/report'
      autoload :Wizard, 'kangaroo/util/proxy/wizard'

      def initialize client, service, *curry_args
        @client = client
        @service = service
        @curry_args = curry_args
      end

      def call! name, *args
        @client.call @service, name, *__curry__(*args)
        
      # rescue => f
      #   case f.message
      #   when /^Method not found\: (.+)/
      #     raise NoMethodError, $1, caller + ["OpenERP Server Traceback:"] + f.backtrace.reverse + [''] + caller
      #   else
      #     message = "OpenERP Server Exception " + f.message.to_s
      #     
      #     raise message + ([''] + f.backtrace.reverse[0..-2]).join("\n")
      #   end
      end

      protected
      def __curry__ *args
        @curry_args + args
      end
    end
  end
end