module Kangaroo
  module Util
    class Proxy::Report < Proxy
      # Initiate report generation
      #
      # @param object
      # @param ids
      # @param datas
      # @param context
      # @return id to check status on/get report
      def report object, ids, datas = {}, context = {}
        call! :report, object, ids, data, context
      end
      
      # Check status on/get report by id
      #
      # @param id
      # @return [Hash] report state, report result and format
      def report_get id
        call! report_get, id
      end
    end
  end
end
