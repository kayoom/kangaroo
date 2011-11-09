require 'active_support/core_ext/module'

module Kangaroo
  module Model
    module Finder
      RELATION_DELEGATES = %w(where limit offset order select context reverse)
      delegate *(RELATION_DELEGATES + [:to => :relation])
      
      def find_in_batches batch_size = 100
        relation.find_in_batches(batch_size)
      end

      # Retrieve all records
      #
      # @return [Array] records
      def all
        relation.all
      end

      # ActiveRecord-ish find method
      #
      # @overload find(id)
      #   Find a record by id
      #   @param [Number] id
      # @overload find(keyword)
      #   Find all, first or last record
      #   @param [String, Symbol] keyword :all, :first or :last
      def find id_or_keyword
        case id_or_keyword
        when :all, 'all'
          all
        when :first, 'first'
          first
        when :last, 'last'
          last
        else
          super
        end
      end

      def exists? ids
        where(:id => ids).exists?
      end

      # Retrieve first record
      #
      # @return record
      def first
        relation.first
      end

      # Retrieve last record
      #
      # @return record
      def last
        relation.last
      end

      # Count number of records
      #
      # @return [Number]
      def count
        count_by
      end

      # @private
      # Search, read and instantiate records at once
      #
      # @param [Array, Hash, String] conditions
      # @param [Hash] search_options
      # @param [Hash] read_options
      # @return [Array]
      def search_and_read conditions, search_options = {}, read_options = {}
        ids = search conditions, search_options.merge(:count => false)
        return [] if ids.blank?
        
        read ids, read_options
      end

      # @private
      # Count objects matching the conditions
      #
      # @param [Array, Hash, String] conditions
      # @param [Hash] search options
      # @return [Number]
      def count_by conditions = [], search_options = {}
        search conditions, search_options.merge(:count => true)
      end

      # @private
      def relation
        @relation ||= Relation.new self
      end
    end
  end
end