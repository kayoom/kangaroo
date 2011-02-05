module Kangaroo
  module Util
    class Loader
      attr_accessor :model_names, :models
      
      def initialize model_names, options = {}
        @logger = options[:logger] || Logger.new(STDOUT)
        @model_names = model_names
        sanitize_model_names
      end
      
      def load!
        @models = model_names.sum([]) do |model_name|
          Oo::Ir::Model.where("model ilike #{model_name}").all
        end.uniq
        
        @models.sort_by! &:length_of_model_name
        
        @models.map do |model|
          RubyAdapter::Base.new(model).to_ruby
        end
      end
      
      protected
      def sanitize_model_names
        @model_names = if Array === @model_names
          @model_names.map do |model_name|
            replace_wildcard model_name
          end
        else
          ['%']
        end
      end
      
      def replace_wildcard string
        string.gsub '*', '%'
      end
    end
  end
end