require 'kangaroo/model/attributes'

module Kangaroo
  module Model
    class Field
      include Attributes

      attr_accessor :name

      def initialize name, attributes = {}
        @attributes = {}
        @name = name

        attributes.each do |key, val|
          write_attribute key, val
        end
      end
    end
  end
end