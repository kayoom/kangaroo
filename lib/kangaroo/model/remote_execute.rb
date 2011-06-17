module Kangaroo
  module Model
    module RemoteExecute
      def call name, *args
        return_value = remote.call! name, ids_for_execute, *args
        
        # TODO: handle warnings etc
        if Hash === return_value && return_value[:value]
          handle_updated_values return_value[:value] 
          self
        else
          return_value
        end
      end
      
      protected
      def handle_updated_values values
        values.each do |key, value|
          write_attribute key, value
        end
      end
      
      private
      def ids_for_execute
        new_record? ? [] : [id]
      end
    end
  end
end