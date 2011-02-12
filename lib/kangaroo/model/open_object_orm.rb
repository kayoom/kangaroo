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
        fields = options[:fields]
        fields = attribute_names if options[:fields].blank?
        context = options[:context]

        [].tap do |result|
          remote.read(ids, fields, context).each do |attributes|
            position = ids.index(attributes[:id].to_i)
            result[position] = instantiate attributes, context
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
          :fields => attribute_names
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
          :fields => attribute_names
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
    end
  end
end