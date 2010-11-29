module Kangaroo
  module Queries
    def self.included base
      base.extend ClassMethods
    end
    
    module ClassMethods
      def all query_parameters = {}        
        ids = search query_parameters
        
        read *ids
      end      
    end
  end
end