module Kangaroo
  module Model
    module Inspector
      extend ActiveSupport::Concern

      # @private
      def inspect
        inspect_wrap do |str|
          str << [inspect_id, *inspect_attributes].join(', ')
        end
      end

      private
      def inspect_id
        "id: #{id.inspect}"
      end

      def inspect_attributes
        attributes.to_a.map do |key_val|
          name, value = key_val
          [name, value.inspect].join ": "
        end
      end

      def inspect_wrap
        "".tap do |str|
          str << "<#{self.class.name} "
          yield str
          str << ">"
        end
      end

      # @private
      module ClassMethods
        def inspect
          inspect_wrap do |str|
            str << ['id', *attribute_names].join(', ')
          end
        end

        private
        def inspect_wrap
          "".tap do |str|
            str << "<#{name} "
            yield str
            str << ">"
          end
        end
      end
    end
  end
end