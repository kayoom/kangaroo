module Kangaroo
  class ModelClassCreator    
    def initialize model
      @model = model
    end
    
    def create
      create_class
      define_columns
      
      @klass
    end
    
    protected    
    def define_columns
      @klass.columns = []
      
      @model.fields.each do |name, properties|        
        @klass.columns << (c = Column.new(name, properties))
        
        define_attribute_methods c
        add_validations c
      end      
    end
    
    def define_attribute_methods column
      if column.readonly?
        @klass.define_reader_methods column.name
      else
        @klass.define_attribute_methods column.name
      end
    end
    
    def add_validations column
      if column.required?
        @klass.validates_presence_of column.name
      end
    end
    
    def create_class
      @klass = supplement_constants *@model.model_class_name.split("::")[1..-1]
      
      @klass
    end
    
    private
    def supplement_constants *constants
      scope = ::Oo      
      
      constants[0..-2].each do |c|        
        scope.const_set c, Module.new unless scope.const_defined?(c)        
        
        scope = scope.const_get c
      end
      
      scope.const_set constants.last, Class.new(Kangaroo::Base) unless scope.const_defined?(constants.last)
      scope.const_get constants.last
    end
  end
end
