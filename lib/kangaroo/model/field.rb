require 'kangaroo/model/attributes'

module Kangaroo
  module Model
    class Field
      autoload :Readonly, 'kangaroo/model/field/readonly'
      
      include Attributes
      include Readonly

      attr_accessor :name
      define_multiple_accessors :change_default, :context, :digits, :domain, :fnct_inv, :fnct_inv_arg, 
                                :fnct_search, :func_method, :func_obj, :function, :help, :invisible, 
                                :readonly, :related_columns, :relation, :required, :select, :selectable, 
                                :selection, :size, :states, :store, :string, :third_table, :translate, 
                                :type, :namespace
                                
      def initialize name, attributes = {}
        @attributes = {}
        @name = name
        
        attributes.each do |key, val|
          write_attribute key, val
        end
        
        self.states = attributes[:states] if attributes[:states]
      end
      
      def required?
        !!required
      end
      
      def states= states
        coerced_states = {}
        
        states.each do |name, effects|
          coerced_states[name.to_s] = Hash[effects]
        end
        write_attribute :states, coerced_states
      end
      
      def relation_class
        @relation_class ||= namespace.class_for relation
      end
    end
  end
end

