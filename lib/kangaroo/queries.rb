module Kangaroo
  module Queries
    def self.included base
      base.extend ClassMethods
    end
    
    module ClassMethods
      def all conditions = []
        ids = search(conditions)
        
        read *ids
      end
    end
  end
end