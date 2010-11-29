module Kangaroo
  class ModelClassCreator    
    def initialize model
      @model = model
    end
    
    def create
      create_class
      define_attribute_methods
      validations_for_required_fields
      
      @klass
    end
    
    protected
    def validations_for_required_fields
      @model.required_fields.each do |field|
        @klass.validates_presence_of field.name
      end
    end
    
    def define_attribute_methods
      column_names = @model.fields.map(&:name)
      @klass.define_attribute_methods *column_names
      @klass.column_names = column_names.sort
    end
    
    def create_class
      @klass = supplement_constants *@model.model_class_name.split("::")[1..-1]
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