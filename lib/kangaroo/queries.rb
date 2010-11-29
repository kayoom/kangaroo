module Kangaroo
  module Queries
    def self.included base
      base.extend ClassMethods
    end
    
    def reload
      @attributes = database.read(self.class, id).stringify_keys
      @changed_attributes = {}
      
      self
    end
    
    def save  
      if valid? && database.write(self.class, [id], updateable_attributes)
        @changed_attributes = {}
        
        true
      else
        false
      end
    end
    
    protected
    def updateable_attributes
      @attributes.slice *changed.map(&:to_s)
    end
    
    module ClassMethods
      def all query_parameters = {}        
        ids = search query_parameters
        
        return [] if ids.empty?
        
        ids << {:db_name => query_parameters[:db_name]}
        read *ids
      end      
      
      def first query_parameters = {}
        all(query_parameters.merge(:limit => 1)).first
      end
      
      def find id_or_keyword, query_parameters = {}
        case id_or_keyword
        when :all
          all query_parameters
        when :first
          first query_parameters
        when Array
          all merge_condition(query_parameters, :id => id_or_keyword)
        else
          first merge_condition(query_parameters, :id => id_or_keyword)
        end
      end
      
      def count query_parameters = {}
        search(query_parameters).size
      end
      alias_method :size, :count
      alias_method :length, :count
      
      protected
      def merge_condition query_parameters, condition
        query_parameters[:conditions] ||= []
        query_parameters[:conditions] += [condition]
        query_parameters
      end
    end
  end
end