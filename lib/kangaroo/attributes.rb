module Kangaroo
  module Attributes
    def self.included base
      base.extend ClassMethods      
    end
    
    def read_attribute name
      @attributes[name.to_s]
    end
    
    def write_attribute name, value
      @attributes[name.to_s] = value
    end
    
    def attributes= attributes
      attributes.except('id', :id).map do |key_value|
        __send__ "#{key_value.first}=", key_value.last
      end
    end
    
    def attributes
      {}.tap do |attributes|
        @attributes.keys.each do |key|
          attributes[key] = send(key)
        end
      end
    end
    
    module ClassMethods
      def define_reader_methods *methods
        methods.each do |method|
          define_method method do
            read_attribute method
          end
        end
      end 
      
      def column_names
        columns.map &:name
      end
      
      def define_attribute_methods *methods
        super methods.map(&:to_s)
        
        methods.each do |method|
          define_method method do
            read_attribute method
          end
          
          define_method "#{method}=" do |value|
            attribute_will_change! method
            write_attribute method, value
          end
        end
      end
    end
  end
end