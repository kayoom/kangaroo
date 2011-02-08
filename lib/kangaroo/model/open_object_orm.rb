require 'kangaroo/model/condition_normalizer'

module Kangaroo
  module Model
    module OpenObjectOrm
      include ConditionNormalizer

      def self.included klass
      end

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

      def read ids, fields, context = {}
        remote.read(ids, fields, context).map do |attributes|
          instantiate attributes, context
        end
      end
    end
  end
end