module Kangaroo
  module Model
    module Finder
      RELATION_DELEGATES = %w(where limit offset order select context)
      
      RELATION_DELEGATES.each do |d|
        define_method d do |*args|
          relation.send d, *args
        end
      end
      
      # Retrieve all records
      #
      # @return [Array] records
      def all
        relation.all
      end
      
      # Retrieve first record
      #
      # @return records
      def first
        relation.first
      end
      
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
      
      protected
      def relation
        Relation.new self
      end
      
      # def with_exclusive_scope
      #   
      # end
    end
  end
end