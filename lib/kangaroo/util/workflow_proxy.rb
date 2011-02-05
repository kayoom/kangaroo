module Kangaroo
  module Util
    class WorkflowProxy < Proxy
      # Advance workflow via exec_workflow on OpenERPs object service.
      #
      # @param name function name to call
      # @param model_name OpenERP model to execute the function on
      # @return returned value
      def call! name, model_name, id
        super :exec_workflow, model_name, id, name
      end
    end
  end
end