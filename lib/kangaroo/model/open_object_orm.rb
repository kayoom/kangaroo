require 'kangaroo/model/condition_normalizer'
require 'kangaroo/model/field'

module Kangaroo
  module Model
    module OpenObjectOrm
      include ConditionNormalizer

      # Search for records in the OpenERP database
      #
      # @param [Hash, Array, String] conditions
      # @param [Hash] options
      # @option options [Number] limit
      # @option options [Number] offset
      # @option options [String] order
      # @option options [Hash] context
      # @option options [boolean] count
      # @return list of ids
      def search conditions, options = {}
        options = {
          :limit  => false,
          :offset => 0
        }.merge(options)

        remote.search normalize_conditions(conditions),
                      options[:offset],
                      options[:limit],
                      options[:order],
                      options[:context],
                      options[:count]
      end

      # Read records and instantiate them
      #
      # @param [Array] ids
      # @param [Hash] options
      # @option options [Array] fields
      # @option options [Hash] context
      # @return [Array] list of Kangaroo::Model::Base instances
      def read ids, options = {}
        fields = if options[:fields].present?
          options[:fields] & attribute_names
        else
          attribute_names
        end
        
        context = options[:context]
        ids = ids.reverse if options[:reverse_flag]

        [].tap do |result|
          remote.read(ids, fields, context).each do |attributes|
            position = ids.index(attributes[:id].to_i)
            result[position] = instantiate(attributes, context).tap do |record|
              record.attribute_names = fields.map &:to_s
            end
          end
        end
      end

      # Retrieve field informations
      #
      # @param [Hash] options
      # @option options [Array] fields
      # @option options [Hash] context
      # @return [Hash]
      def fields_get options = {}
        options = {
          :fields => attribute_names,
          :context => {}
        }.merge(options)

        remote.fields_get(options[:fields], options[:context]).map do |key, val|
          Field.new key, val
        end
      end

      # Create a OpenObject record.
      #
      # @param [Hash] attributes
      # @param [Hash] options
      # @option options [Hash] context
      # @return [Number] id
      def create_record attributes, options = {}
        remote.create attributes, options[:context]
      end


      # Fetch default attribute values from OpenERP database
      #
      # @param [Hash] options
      # @option options [Array] fields
      # @option options [Hash] context
      # @return [Hash] default values
      def default_get options = {}
        options = {
          :fields => attribute_names,
          :context => {}
        }.merge(options)

        remote.default_get options[:fields], options[:context]
      end

      # Write values to records
      #
      # @param [Array] ids
      # @param [Hash] attributes
      # @param [Hash] options
      # @option options [Hash] context
      # @return [boolean] true/false
      def write_record ids, attributes, options = {}
        remote.write ids, attributes, options[:context]
      end

      # Remove records
      #
      # @param [Array] ids
      # @param [Hash] options
      # @option options [Hash] context
      # @return [boolean] true/false
      def unlink ids, options = {}
        remote.unlink ids, options[:context]
      end
      
      # Get values from information repository for this model
      # e.g.
      #     
      #     Oo::Product::Product.ir_get 'default'
      #     # => {:supplier_taxes_id => [1], :taxes_id => [2]}
      #
      # @param [Symbol] key1
      # @param [Symbol] key2
      # @return values
      def ir_get key1, key2 = false
        namespace.ir_get key1, key2, self
      end
      
      # Export data via OpenERPs export_data method
      # (which is used by OpenERP to export to CSV)
      #
      # @param [Array] ids
      # @param [Array] fields
      # @param [Hash] context
      # @option options [boolean] import_comp Force import compatibility
      def export_data ids, fields = attribute_names, context = {}
        remote.export_data(ids, fields, context)[:datas]
      end
      
      # Import data via OpenERPs import data method
      # (which is used by OpenERP to import by CSV)
      #
      # @param [Array] fields
      # @param [Array<Array>] datas
      # @param [Hash] options
      # @option options mode "init" or "update", defaults to "init"
      # @option options current_module
      # @option options [boolean] noupdate, defaults to false
      # @option options filename optional file to store partial import state for recovery
      def import_data fields, datas, options = {}
        remote.import_data(fields, datas, options)
      end
    end
  end
end