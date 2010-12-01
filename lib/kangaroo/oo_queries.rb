module Kangaroo
  module OoQueries
    OPERATORS = (%w(= != > >= < <= ilike like in child_of parent_left parent_right) + ['not in']).join("|").freeze
    CONDITION_PATTERN = /\A(.*)\s+(#{OPERATORS})\s+(.*)\Z/i.freeze
    
    def self.included base
      base.extend ClassMethods
    end
    
    
    module ClassMethods
      def search query_parameters = {}
        conditions = query_parameters[:conditions] || []
        conditions = conditions.sum([]) {|c| convert_condition(c) }
        
        offset = query_parameters[:offset] || 0
        limit = query_parameters[:limit] || false
        context = {}
        
        database.search(self, conditions, offset, limit, context)
      end
      
      def read ids, column_names = nil
        
        database.read(self, ids, column_names, {}).map do |record|
          instantiate(record)
        end
      end
      
      def default_get *fields
        database.default_get(self, fields, {})
      end
      
      protected      
      def convert_condition condition
        case condition
        when Hash
          [].tap do |arr|
            condition.each do |key, value|
              op = value.is_a?(Array) ? 'in' : '='
              arr << [key, op, value]
            end
          end
        when String
          [CONDITION_PATTERN.match(condition).captures]
        when Array
          #TODO
        end
      end
    end
  end
end