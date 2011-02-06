module Kangaroo
  module DefaultAttributes
    # @private
    def self.included base
      base.extend ClassMethods      
      base.add_default_attribute_initializer
    end

    module ClassMethods
      def add_default_attribute_initializer
        before_initialize do
          self.class.default_attributes.each do |name, value|
            write_attribute name, value
          end
        end
      end
      
      def default_attributes
        remote.default_get field_names
      end
    end
  end
end