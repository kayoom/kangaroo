require 'kangaroo/model/condition_normalizer'

module Kangaroo
  module Model
    module OpenObjectOrm
      include ConditionNormalizer
      
      def search conditions
        remote.search normalize_conditions(conditions)
      end
    end
  end
end