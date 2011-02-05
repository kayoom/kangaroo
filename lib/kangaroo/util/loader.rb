require 'active_support/core_ext/enumerable'
require 'kangaroo/ruby_adapter/base'
require 'oo'

module Kangaroo
  module Util
    class Loader
      attr_accessor :model_names, :models
      
      def initialize model_names
        @model_names = model_names
        sanitize_model_names
      end
      
      def load!
        load_oo_models
        sort_oo_models
        adapt_oo_models
      end
      
      protected
      def load_oo_models
        @models = model_names.sum([]) do |model_name|
          Oo::Ir::Model.where("model ilike #{model_name}").all
        end.uniq
      end
      
      def sort_oo_models
        @models = @models.sort_by &:length_of_model_name
      end
      
      def adapt_oo_models
        @models.map do |model|
          RubyAdapter::Base.new(model).to_ruby
        end
      end
      
      def sanitize_model_names
        @model_names = case @model_names
        when nil, []
          raise 'No models specified.'
        when :all
          ['%']
        when Array
          @model_names.map do |model_name|
            replace_wildcard model_name
          end
        else
          raise "Expected list of models or :all, got #{@model_names.inspect}"
        end
      end
      
      def replace_wildcard string
        string.gsub '*', '%'
      end
    end
  end
end