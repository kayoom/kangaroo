module Kangaroo
  module RubyAdapter
    class Base
      
    end
  end
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
      @klass.clear_column_names
      @klass.clear_attribute_names
      
      @model.fields.each do |name, properties|        
        @klass.columns << (c = Column.new(name, properties).freeze)
        
        define_attribute_methods c
        add_validations c
        add_associations c
      end      
    end
    
    def define_attribute_methods column
      name, field = column.name, nil
      
      if column.association?
        name, field = column.association.id_name, column.association.field
      end
      
      # if column.readonly?
      #   @klass.define_reader_method column.attribute, column.column
      # else
        @klass.define_attribute_method column.attribute, column.column
      # end
      
      @klass.column_names << column.column.to_s
      @klass.attribute_names << column.attribute.to_s
    end
    
    def add_associations column      
      if column.association? && !column.association.property?
        send "add_#{column.association.type*'2'}_association", column
      end
    end
    
    def add_many2many_association column ; end
    def add_one2one_association column ; end

    def add_one2many_association column
      a = column.association

      @klass.class_eval <<-RUBY
        def #{a.name}
          ids = #{a.id_name}
          
          return [] if ids.blank?
          
          @#{a.name}_relation ||= '#{a.target_class_name}'.constantize.where(:id => ids)
        end
      RUBY
    end
    
    def add_many2one_association column
      a = column.association
      
      @klass.class_eval <<-RUBY
        def #{a.name}
          id = Array(#{a.id_name}).first
          
          return nil unless id
          
          @#{a.name}_relation ||= '#{a.target_class_name}'.constantize.where(:id => id).limit(1)
        end
      RUBY
    end
    
    
    def add_validations column
      if column.required?
        @klass.validates_presence_of column.attribute
      end
      
      if column.selection? && !column.association?
        @klass.validates_inclusion_of column.attribute, 
                                      :in => column.selection.keys, 
                                      :unless => proc {|record| !column.required? && !record.send(column.attribute)},
                                      :message => "must be one of (#{column.selection.keys * ','})"
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
