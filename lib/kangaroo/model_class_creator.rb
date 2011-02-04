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
      @klass.clear_column_names
      @klass.clear_attribute_names
      
      @model.fields.except(:id).each do |name, properties|        
        @klass.columns << (c = Column.new(name, properties).freeze)
        
        if c.association?
          define_association_methods c
        else
          define_attribute_methods c.attribute.to_s, c.column.to_s
        end
        
        add_validations c
      end      
    end
    
    def define_attribute_methods attribute, column
      @klass.define_attribute_method attribute, column

      @klass.column_names << column
      @klass.attribute_names << attribute
    end
    
    def define_association_methods column
      define_attribute_methods column.association.id_name, column.column
      add_associations column.association
    end
    
    def add_associations association   
      send "add_#{association.type.last}_association", association
    end
    

    def add_many_association a
      @klass.class_eval <<-RUBY
        def #{a.name}
          ids = #{a.id_name}
          
          return [] if ids.blank?
          @#{a.name}_relation ||= '#{a.target_class_name}'.constantize.where(:id => ids)
        end
        
        def #{a.name}= records
          ids = (records || []).map :id
          
          write_attribute '#{a.id_name}', ids
          records
        end
      RUBY
    end
    
    def add_one_association a
      @klass.class_eval <<-RUBY
        def #{a.name}
          id = Array(#{a.id_name}).first
          
          return nil unless id
          
          @#{a.name}_relation ||= '#{a.target_class_name}'.constantize.where(:id => id).limit(1)
        end
        
        def #{a.name}= record
          return nil if record.nil?
          
          id = record.id
          
          write_attribute '#{a.id_name}', id
          record
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
