require 'active_support/core_ext/module/delegation'
require 'kangaroo/relation'
require 'kangaroo/oo_queries'
require 'kangaroo/queries'

module Kangaroo
  class Base
    
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks
    include ActiveModel::Validations
    
    class_attribute :column_names
    
    attr_reader :attributes
    attr_accessor :database
    
    define_model_callbacks :initialize
    
    include OoQueries
    include Queries
    
    
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
    
    def attributes= attributes
      attributes.map do |key, value|
        __send__ "#{key}=", value
      end
    end
    
    def inspect
      "#<#{self.class} ".tap do |s|
        attr = self.class.column_names.map do |c|
          [c.to_s, send(c).inspect] * ": "
        end
        
        s << attr * ", "
      
        s << ">"
      end
    end
    
    
    class << self      
      delegate  :where,
                :offset,
                :limit,
                :using,
                :to => :relation
                
      def relation
        @relation ||= Relation.new self
      end
      
      def database db_name = nil
        if db_name.nil?
          Kangaroo.default
        elsif db_name.is_a?(Database)
          db_name
        else
          Kangaroo.databases[db_name.to_sym]
        end
      end
      
      def oo_model_name
        name[4..-1].underscore.gsub('/','.')
      end      
      
      def instantiate attributes
        allocate.tap do |object|
          object.instance_variable_set :@attributes, attributes.stringify_keys
          # object.instance_variable_set :@attributes_cache, {}
          
          object.instance_variable_set :@new_record, false
          # object.instance_variable_set :@readonly, false
          # object.instance_variable_set :@destroyed, false
          # object.instance_variable_set :@marked_for_destruction, false
          # object.instance_variable_set :@previously_changed, {}
          # object.instance_variable_set :@changed_attributes, {}

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