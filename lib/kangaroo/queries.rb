module Kangaroo
  module Queries
    def self.included base
      base.extend ClassMethods
    end
    
    def reload
      @attributes = database.read(self.class, id, self.class.column_names).stringify_keys
      @changed_attributes = {}
      
      self
    end
    
    def save options = {}
      skip_validation = (options[:validate] == false)
      
      (skip_validation || valid?) && create_or_update
    end
    
    protected
    def create_or_update
      new_record? ? create_record : write_record
    end
    
    def write_record
      if database.write(self.class, [id], updateable_attributes)
        reload
        
        true
      else
        false
      end
    end
    
    def create_record
      id = database.create(self.class, updateable_attributes)
      if id.is_a?(Integer)
        @id = id
        @new_record = false
        reload
        
        true    
      else
        false
      end
    end
    
    def updateable_attributes
      @attributes.slice *changed.map(&:to_s)
    end
    
    module ClassMethods    
      def create attributes = {}
        new(attributes).tap do |record|
          record.save
        end
      end
      
      def default_attributes
        default_get *column_names
      end
            
      def all query_parameters = {}     
        column_names = query_parameters.delete(:select)
        column_names = self.column_names if column_names.blank?
        
        ids = search query_parameters
        
        return [] if ids.empty?
        
        read ids, column_names
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