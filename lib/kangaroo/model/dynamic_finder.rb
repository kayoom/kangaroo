module Kangaroo
  module Model
    module DynamicFinder
      
      def respond_to? name, *args
        case name.to_s
        when /^find_(all|first|last|)_?by_(.+)$/
          true
        else
          super
        end
      end
      
      protected
      def method_missing name, *args
        name = name.to_s
        case name
        when /^find_(all|first|last|)_?by_(.+)$/
          finder = $1.blank? ? :first : $1
          fields = $2.split '_and_'
          define_dynamic_finder name, fields do |relation|
            relation.send finder
          end
          send name, *args
        else
          super
        end
      end
      
      def define_dynamic_finder name, keys
        singleton_class.send :define_method, name do |*values|
          conditions = {}
          keys.each_with_index do |key, i|
            conditions[key] = values[i]
          end
          
          yield where(conditions)
        end
      end
    end
  end
end