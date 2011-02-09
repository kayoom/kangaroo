module Kangaroo
  module Model
    module Finder
      def self.included klass
        klass.extend ClassMethods
      end
      
      module ClassMethods
        
      end
    end
  end
end