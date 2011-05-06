module Kangaroo
  module RubyAdapter
    module Fields
      def add_fields
        @ruby_model.define_multiple_accessors *field_names
      end
      
      protected
      def field_names
        fields.map(&:name) - [:id]
      end
      
      def fields
        @fields ||= @ruby_model.fields
      end
    end
  end
end