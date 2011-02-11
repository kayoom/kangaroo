module Kangaroo
  module Model
    module Finder
      RELATION_DELEGATES = %w(where limit offset order select context)
      
      RELATION_DELEGATES.each do |d|
        define_method d do |*args|
          relation.send d, *args
        end
      end
      
      def all
        search_and_read []
      end
      
      def first
        id = search [], :limit => 1
        return nil if id.blank?
        
        read(id).first
      end
      
      def count conditions = [], search_options = {}
        search conditions, search_options.merge(:count => true)
      end

      def search_and_read conditions, search_options = {}, read_options = {}
        ids = search conditions, search_options
        return [] if ids.blank?
        
        read ids, read_options
      end
      
      protected
      def relation
        Relation.new self
      end
    end
  end
end