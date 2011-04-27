require 'kangaroo/model/attributes'

module Kangaroo
  module Model
    class Field
      include Attributes

      attr_accessor :name
      define_multiple_accessors :change_default, :context, :digits, :domain, :fnct_inv, :fnct_inv_arg, 
                                :fnct_search, :func_method, :func_obj, :function, :help, :invisible, 
                                :readonly, :related_columns, :relation, :required, :select, :selectable, 
                                :selection, :size, :states, :store, :string, :third_table, :translate, 
                                :type
                                
      def initialize name, attributes = {}
        @attributes = {}
        @name = name
        
        attributes.each do |key, val|
          setter = "#{key}="
          
          unless respond_to?(setter)
            self.class.class_eval do
              define_multiple_accessors key.to_sym
            end
          end
            
          send setter, val
        end
      end
      
      def readonly?
        !!readonly
      end
      
      def eventually_readonly?
        !!readonly || (states.present? && states.any? { |key, value|
          !!value['readonly']
        })
      end
      
      def always_readonly?
        readonly? && (states.blank? || states.all? { |key, value|
          value['readonly'].nil? || value['readonly'] == true
        })
      end
      
      def readonly_in? state
        s = states && states[state.to_s]
        if readonly?
          return true unless s
          
          s['readonly'] == true
        else
          return false unless s
          
          s['readonly'] == false
        end
      end
      
      def states= states
        coerced_states = {}
        
        states.each do |name, effects|
          coerced_states[name.to_s] = Hash[effects]
        end
        write_attribute :states, coerced_states
      end
    end
  end
end

