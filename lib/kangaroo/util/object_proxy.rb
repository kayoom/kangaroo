module Kangaroo
  module Util
    class ObjectProxy < Proxy
      # Call function via execute on OpenERPs object service.
      #
      # @param name function name to call
      # @param model_name OpenERP model to execute the function on
      # @return returned value
      def call! name, model_name, *args
        super :execute, model_name, name, *args
      end
      
      # Advance workflow
      #
      # @param model_name OpenERP model which workflow should be advanced
      # @param id
      # @param signal
      # @return result
      def exec_workflow
        
      end
      
      
      # Create a new record
      #
      # @param model_name OpenERP model to create record from
      # @param [Hash] attributes attributes to set on new record
      # @return id of new record
      def create model_name, attributes
        call! :create, model_name, attributes
      end
      
      # Search for records
      #
      # @param model_name OpenERP model to search
      # @param [Array] conditions search conditions
      # @param offset number of records to skip, defaults to 0
      # @param limit max number of records, defaults to nil
      def search model_name, conditions, offset = 0, limit = nil
        call! :search, model_name, conditions, offset, limit
      end
      
      # Read fields from records
      #
      # @param model_name OpenERP model to read from
      # @param [Array] ids ids of record to read fields from
      # @param [Array] fields fields to read
      # @return [Array] Array of Hashes with field names and values 
      def read model_name, ids, fields = []
        call! :read, model_name, ids, fields
      end
      
      # Update records
      #
      # @param model_name OpenERP model to update
      # @param [Array] ids ids of record to update
      # @param [Hash] values Hash of field names => values
      # @return true
      def write model_name, ids, values
        call! :write, model_name, ids, values
      end
      
      # Delete records
      #
      # @param model_name OpenERP model to remove record from
      # @param [Array] ids ids to to remove
      # @return true
      def unlink model_name, ids
        call! :unlink, model_name, ids
      end
    end
  end
end
