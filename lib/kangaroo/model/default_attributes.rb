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
      def default_attributes
        default_get :fields => attribute_names
      end
    end
  end
end