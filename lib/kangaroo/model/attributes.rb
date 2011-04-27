require 'active_model/dirty'
require 'active_support/core_ext/class/attribute'

module Kangaroo
  module Attributes
    # @private
    def self.included base
      base.send :include, ActiveModel::Dirty
      base.extend ClassMethods
      
      base.send :class_attribute, :attribute_names
    end

    # Read an attribute value by name
    #
    # @param [String, Symbol] name attribute name
    # @return attribute value
    def read_attribute name
      @attributes[name.to_s]
    end

    # Write an attribute by name
    #
    # @param [String, Symbol] name attribute name
    # @param value attribute value to set
    # @return attribute value
    def write_attribute name, value
      name = name.to_s
      attribute_will_change! name unless @attributes[name] == value
      @attributes[name] = value
    end

    # Mass set attributes. Attribute values are set via setters, not directly stored
    # in the @attributes Hash.
    #
    # @param [Hash] attributes Hash of attribute names and values
    # @return [Hash] attributes
    def attributes= attributes
      attributes.except('id', :id).map do |key_value|
        __send__ "#{key_value.first}=", key_value.last
      end

      self.attributes
    end

    # Read all attributes. Attributes are read via getters.
    #
    # @return [Hash] attributes
    def attributes
      {}.tap do |attributes|
        attribute_names.each do |key|
          attributes[key] = send(key)
        end
      end
    end

    # Freeze this object
    def freeze
      @changed_attributes.freeze
      @attributes.freeze
      super
    end

    module ClassMethods
      # If you need to customize your models, e.g. add attributes
      # not covered by fields_get, you can call {extend_attribute_methods}
      #
      # @param [Array] attributes list of attribute names to define accessors for
      def extend_attribute_methods *attributes
        attributes.flatten.each do |attr|
          next if attribute_names.include?(attr.to_s)
          define_accessors attr
        end
      end

      # Define setter
      #
      # @param [String, Symbol] attribute_name
      def define_setter attribute_name
        define_method "#{attribute_name}=" do |value|
          write_attribute attribute_name, value
        end
      end

      # Define getter
      #
      # @param [String, Symbol] attribute_name
      def define_getter attribute_name
        define_method attribute_name do
          read_attribute attribute_name
        end
      end

      # Define getter and setter for an attribute
      #
      # @param [String, Symbol] attribute_name
      def define_accessors attribute_name
        define_getter attribute_name
        define_setter attribute_name

        self.attribute_names ||= []
        attribute_names << attribute_name.to_s
      end

      # Define getters and setters for attributes
      #
      # @param [Array] attribute_names
      def define_multiple_accessors *attribute_names
        define_attribute_methods attribute_names.map(&:to_s)

        attribute_names.each do |attribute_name|
          define_accessors attribute_name
        end
      end
    end
  end
end