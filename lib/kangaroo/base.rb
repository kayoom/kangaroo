module Kangaroo
  class Base
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks
    
    attr_accessor :attributes
    

    class << self
      def instantiate attributes
        allocate.tap do |object|
          object.instance_variable_set :@attributes, attributes
          object.instance_variable_set :@attributes_cache, {}
          
          object.instance_variable_set :@new_record, false
          object.instance_variable_set :@readonly, false
          object.instance_variable_set :@destroyed, false
          object.instance_variable_set :@marked_for_destruction, false
          object.instance_variable_set :@previously_changed, {}
          object.instance_variable_set :@changed_attributes, {}

          object.send :_run_find_callbacks
          object.send :_run_initialize_callbacks
        end
      end
    end    
  end
end