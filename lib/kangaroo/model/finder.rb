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
      
      def count
        search [], :count => true
      end

      def search_and_read conditions, options = {}
        fields = options.delete :select
        ids = search conditions, options
        return [] if ids.blank?
        
        read_options = { :context => options[:context] }
        read_options.merge! :fields => fields unless fields.blank?
        read ids, read_options
      end
      
      protected
      def relation
        Relation.new self
      end
    end
  end
end