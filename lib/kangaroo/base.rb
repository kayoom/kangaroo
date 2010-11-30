require 'active_support/core_ext/module/delegation'
require 'kangaroo/relation'
require 'kangaroo/oo_queries'
require 'kangaroo/queries'
require 'kangaroo/column'
require 'kangaroo/attributes'

module Kangaroo
  class Base    
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks
    include ActiveModel::Validations
    include ActiveModel::Dirty
    include OoQueries
    include Queries
    include Attributes  
    
    class_attribute :columns
    
    attr_accessor :database, :id
    
    define_model_callbacks :initialize
    define_model_callbacks :find
      
    
    def initialize attributes = {}
      @new_record = true
      @attributes = self.class.default_attributes.stringify_keys
      @database = self.class.database
      
      _run_initialize_callbacks do
        self.attributes = attributes
      end
    end
    
    def new_record?
      @new_record
    end
    
    def inspect
      "#<#{self.class} ".tap do |s|
        s << "id: " << id.to_s << ", "
        
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
        Relation.new self
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
        name[4..-1].underscore.gsub '/', '.'
      end     
      
      def instantiate attributes
        attributes = attributes.stringify_keys
        allocate.tap do |object|
          object.instance_variable_set :@attributes, attributes.except('id')
          object.instance_variable_set :@id, attributes['id']
          # object.instance_variable_set :@attributes_cache, {}
          
          object.instance_variable_set :@new_record, false
          # object.instance_variable_set :@readonly, false
          # object.instance_variable_set :@destroyed, false
          # object.instance_variable_set :@marked_for_destruction, false
          # object.instance_variable_set :@previously_changed, {}
          # object.instance_variable_set :@changed_attributes, {}

          object.send :_run_find_callbacks
          object.send :_run_initialize_callbacks
        end
      end      
    end    
  end
end