module Kangaroo
  module Model
    module Finder
      def all
        ids = search []
        return [] if ids.blank?
        
        read ids
      end
      
      def first
        id = search [], :limit => 1
        return nil if id.blank?
        
        read(id).first
      end
      
      def count
        search [], :count => true
      end
      protected
      
    end
  end
end