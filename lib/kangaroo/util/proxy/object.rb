module Kangaroo
  module Util
    class Proxy::Object < Proxy
      # Call function via execute on OpenERPs object service.
      #
      # @param name function name to call
      # @param model_name OpenERP model to execute the function on
      # @return returned value
      def call! name, model_name, *args
        super :execute, model_name, name, *args
      end
      
      # Get for a model
      #
      # @param model_name
      # @param [Array, nil] list of field names, nil for all (default)
      # @param [Hash] context
      # @return [Hash] field names and properties
      def fields_get model_name, fields = nil, context = nil
        call! :fields_get, model_name, fields, context
      end
      
      # Read metadata for records, including
      #   - create user
      #   - create date
      #   - write user 
      #   - write date
      #   - xml id
      #
      # @param model_name
      # @param [Array] ids
      # @param context
      # @param [boolean] details
      # @return [Array] list of Hashes with metadata
      def read_perm model_name, ids, context = nil, details = false
        call! :read_perm, model_name, ids, context, details
      end
      
      # Copy a record
      #
      # @param model_name
      # @param id
      # @param default values to override on copy (defaults to nil)
      # @param context
      # @return attributes of copied record
      def copy model_name, id, default = nil, context = nil
        call! :copy, model_name, id, default, context
      end
      
      # Check if records with given ids exist
      #
      # @param model_name
      # @param ids
      # @param context
      # @return [boolean] true if all exist, else false
      def exists model_name, ids, context = nil
        call! :exists, model_name, ids, context
      end
      
      # Get xml ids for records
      # 
      # @param model_name
      # @param ids
      # @return [Hash] Hash with ids as keys and xml_ids as values
      def get_xml_id model_name, ids
        call! :get_xml_id, model_name, ids
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
      
      # Read records grouped by a field
      #
      # @param [Array] domain search conditions
      # @param [Array] fields field names to read
      # @param [Array] groupby field names to group by
      # @param offset number of records to skip (defaults to 0)
      # @param limit max number of records to retrieve (defaults to nil)
      # @param order order by clause
      # @return [Array]
      def read_group model_name, domain, fields, groupby, offset = 0, limit = nil, order = nil
        call! :read_group,  model_name, domain, fields, groupby, offset, limit, order
      end
    end
  end
end
