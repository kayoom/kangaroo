module Kangaroo
  module Util
    class Proxy::Wizard < Proxy
      # Create Wizard
      #
      # @param [String] name wizard name to create
      # @param [Hash] datas
      # @return [Number] id of created wizard
      def create name, datas = {}
        call! :create, name, datas
      end

      # Execute an action on a wizard
      #
      # @param [Number] id wizard id
      # @param [Hash] datas
      # @param [String] action
      # @param [Hash] context
      # @return return value of action
      def execute id, datas, action = 'init', context = {}
        call! :execute, id, datas, action, context
      end
    end
  end
end