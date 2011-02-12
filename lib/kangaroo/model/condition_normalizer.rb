module Kangaroo
  module Model
    module ConditionNormalizer
      CONDITION_OPERATORS = *%w(= != > >= < <= ilike like in child_of parent_left parent_right).freeze
      CONDITION_PATTERN = /\A(.*)\s+(#{CONDITION_OPERATORS * "|"})\s+(.*)\Z/i.freeze

      protected
      def normalize_conditions conditions
        conditions = if Hash === conditions
          return [] if conditions.blank?
          [conditions]
        else
          Array(conditions)
        end

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
        # Ugly workaround, if you know how to make 'not in' work along the other operators
        # with a single RegExp, please let me now
        if (key_val = string.split("not in")).length > 1
          [key_val.first.strip, 'not in', key_val.last.strip]
        else
          CONDITION_PATTERN.match(string).try(:captures) || string
        end
      end
    end
  end
end