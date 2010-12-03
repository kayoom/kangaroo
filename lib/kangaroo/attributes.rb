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
        self.class.attribute_names.each do |key|
          attributes[key] = send(key)
        end
      end
    end
    
    module ClassMethods
      def define_reader_methods *methods
        methods.each do |method|
          define_reader_method method, method
        end
      end 
      
      def define_reader_method name, attribute = nil   
        attribute ||= name
        
        define_method name do
          read_attribute attribute
        end
      end
      
      def column_names
        @column_names ||= []
      end
      
      def attribute_names
        @attribute_names ||= []
      end
      
      def define_attribute_method name, attribute = nil
        attribute ||= name
        
        define_method name do
          read_attribute attribute
        end
        
        define_method "#{name}=" do |value|
          attribute_will_change! name
          write_attribute attribute, value
        end
      end
      
      def define_attribute_methods *methods
        super methods.map(&:to_s)
        
        methods.each do |method|
          define_attribute_method method, method
        end
      end
    end
  end
end