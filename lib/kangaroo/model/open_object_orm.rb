module Kangaroo
  module Model
    module OpenObjectOrm
      CONDITION_OPERATORS = ['not in', *%w(= != > >= < <= ilike like in child_of parent_left parent_right)].freeze
      CONDITION_PATTERN = /\A(.*)\s+(#{CONDITION_OPERATORS * "|"})\s+(.*)\Z/i.freeze
      
      def search conditions
        remote.search normalize_conditions(conditions)
      end
      
      protected
      def normalize_conditions conditions
        conditions = Hash === conditions ? [conditions] : Array(conditions)
        
        conditions.map do |condition|
          normalize_condition condition
        end
      end
      
      def normalize_condition condition
        case condition
        when Array
          condition
        when Hash
          convert_hash_condition condition
        when String
          convert_string_condition condition
        else
          raise "Expected Array, Hash or String"
        end
      end
      
      def convert_hash_condition condition
        condition.sum([]) do |key_val|
          convert_key_value_condition *key_val
        end
      end
      
      def convert_key_value_condition field, value
        operator = if Array === value
          value = value.map &:to_s
          'in'
        else
          value = value.to_s
          '='
        end

        [field.to_s, operator, value]
      end
      
      def convert_string_condition string
        CONDITION_PATTERN.match(string).try(:captures) || []
      end
    end
  end
end