module Kangaroo
  module OoQueries
    OPERATORS = (%w(= != > >= < <= ilike like in child_of parent_left parent_right) + ['not in']).join("|").freeze
    CONDITION_PATTERN = /\A(.*)\s+(#{OPERATORS})\s+(.*)\Z/.freeze
    
    def self.included base
      base.extend ClassMethods
    end
    
    
    module ClassMethods
      def search *conditions
        conditions = conditions.sum([]) {|c| convert_condition(c) }
        
        database.search(self, conditions)
      end
      
      def read *ids
        database.read(self, ids).map do |record|
          instantiate record
        end
      end
      
      protected      
      def convert_condition condition
        case condition
        when Hash
          eqs = ['=']*condition.size
          
          condition.keys.zip eqs, condition.values
        when String
          [CONDITION_PATTERN.match(condition).captures]
        when Array
          #TODO
        end
      end
    end
  end
end