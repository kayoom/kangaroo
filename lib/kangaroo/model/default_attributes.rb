module Kangaroo
  module DefaultAttributes
    # @private
    def self.included klass
      klass.extend ClassMethods

      klass.before_initialize do
        self.class.default_attributes.each do |name, value|
          write_attribute name, value
        end
      end
    end

    module ClassMethods
      # Fetch default attribute values from OpenERP database
      #
      # @return [Hash] default values
      def default_attributes
        remote.default_get field_names
      end
    end
  end
end