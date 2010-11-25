module Kangaroo
  class Base
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks
    
    attr_reader :attribute
    
    define_model_callbacks :initialize
    
    def initialize attributes = {}
      _run_initialize_callbacks do
        self.attributes = attributes
      end
    end
    
    def read_attribute name
      @attributes[name.to_s]
    end
    
    def write_attribute name, value
      @attributes[name.to_s] = value
    end
    
    class << self
      
      
      def instantiate attributes
        allocate.tap do |object|
          object.instance_variable_set :@attributes, attributes.stringify_keys
          object.instance_variable_set :@attributes_cache, {}
          
          object.instance_variable_set :@new_record, false
          object.instance_variable_set :@readonly, false
          object.instance_variable_set :@destroyed, false
          object.instance_variable_set :@marked_for_destruction, false
          object.instance_variable_set :@previously_changed, {}
          object.instance_variable_set :@changed_attributes, {}

          # object.send :_run_find_callbacks
          object.send :_run_initialize_callbacks
        end
      end
      
      def define_attribute_methods *methods
        methods.each do |method|
          define_method method do
            read_attribute method
          end
          
          define_method "#{method}=" do |value|
            write_attribute method, value
          end
        end
      end
    end    
  end
end