module Kangaroo
  module Util
    class Proxy::Object < Proxy
      # Call function via execute on OpenERPs object service.
      #
      # @param name function name to call
      # @return returned value
      def call! name, *args
        super :execute, name, *args
      end
      
      # Get for a model
      #
      # @param [Array] list of field names, nil for all
      # @param [Hash] context
      # @return [Hash] field names and properties
      def fields_get fields = nil, context = {}
        call! :fields_get, fields, context
      end
      
      # Get default values for a model
      #
      # @param [Array] fields list of field names
      # @param [Hash] context
      def default_get fields = nil, context = {}
        call! :default_get, fields, context
      end
      
      # Get names of records for to-many relationships
      #
      # @param [Array] ids
      # @param [Hash] context
      # @return [Array<Array>] List of arrays [id, name]
      def name_get ids, context = {}
        call! :name_get, ids, context
      end
      
      # Search for records by name
      #
      # @param [String] name
      # @param [Array] args
      # @param [String] operator
      # @param [Hash] context
      # @param [Number] limit
      # @return list of object names
      def name_search name = '', args = nil, operator = 'ilike', context = nil, limit = 100
        call! :name_search, name, args, operator, context, limit
      end
      
      # Read metadata for records, including
      #   - create user
      #   - create date
      #   - write user 
      #   - write date
      #   - xml id
      #
      # @param [Array] ids
      # @param [Hash] context
      # @param [boolean] details
      # @return [Array] list of Hashes with metadata
      def read_perm ids, context = {}, details = false
        call! :read_perm, ids, context, details
      end
      
      # Copy a record
      #
      # @param id
      # @param default values to override on copy (defaults to nil)
      # @param [Hash] context
      # @return attributes of copied record
      def copy id, default = nil, context = {}
        call! :copy, id, default, context
      end
      
      # Check if records with given ids exist
      #
      # @param ids
      # @param context
      # @return [boolean] true if all exist, else false
      def exists ids, context = {}
        call! :exists, ids, context
      end
      
      # Get xml ids for records
      # 
      # @param ids
      # @return [Hash] Hash with ids as keys and xml_ids as values
      def get_xml_id ids
        call! :get_xml_id, ids
      end
      
      # Create a new record
      #
      # @param [Hash] attributes attributes to set on new record
      # @return id of new record
      def create attributes, context = nil
        call! :create, attributes, context
      end
      
      # Search for records
      #
      # @param model_name OpenERP model to search
      # @param [Array] conditions search conditions
      # @param offset number of records to skip, defaults to 0
      # @param limit max number of records, defaults to nil
      def search conditions, offset = 0, limit = nil, order = nil, context = nil, count = false
        call! :search, conditions, offset, limit, order, context, count
      end
      
      # Read fields from records
      #
      # @param [Array] ids ids of record to read fields from
      # @param [Array] fields fields to read
      # @param [Hash] context
      # @return [Array] Array of Hashes with field names and values 
      def read ids, fields = [], context = {}
        call! :read, ids, fields
      end
      
      # Update records
      #
      # @param [Array] ids ids of record to update
      # @param [Hash] values Hash of field names => values
      # @return true
      def write ids, values, context = nil
        call! :write, ids, values, context
      end
      
      # Delete records
      #
      # @param [Array] ids ids to to remove
      # @return true
      def unlink ids, context = nil
        call! :unlink, ids, context
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
      def read_group domain, fields, groupby, offset = 0, limit = nil, order = nil
        call! :read_group, domain, fields, groupby, offset, limit, order
      end
    end
  end
end
