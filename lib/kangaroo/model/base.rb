require 'active_model'
require 'active_support/core_ext/class'

require 'kangaroo/model/relation'
require 'kangaroo/model/attributes'
require 'kangaroo/model/default_attributes'
require 'kangaroo/model/inspector'
require 'kangaroo/model/persistence'
require 'kangaroo/model/open_object_orm'
require 'kangaroo/model/finder'
require 'kangaroo/model/remote_execute'
require 'kangaroo/model/readonly_attributes'
require 'kangaroo/model/required_attributes'
require 'kangaroo/model/data_import'
require 'kangaroo/model/dynamic_finder'
require 'kangaroo/model/associations'
require 'kangaroo/model/mass_import'
require 'kangaroo/util/loader/namespace'

module Kangaroo
  module Model
    class Base
      class_attribute :database, :namespace, :oo_name, :oo_model

      extend ActiveModel::Callbacks
      define_model_callbacks :initialize

      include Attributes
      include Persistence
      include DefaultAttributes
      include Inspector
      extend  OpenObjectOrm
      extend  Finder
      include RemoteExecute
      extend  ReadonlyAttributes
      include RequiredAttributes
      extend  DataImport
      extend  DynamicFinder
      include Associations
      include MassImport
      extend Util::Loader::Namespace

      attr_reader :id

      # Initialize a new object, and set attributes
      #
      # @param [Hash] attributes
      def initialize attributes = {}
        @attributes = {}

        _run_initialize_callbacks do
          self.attributes = attributes
        end
      end

      # Send method calls via xmlrpc to OpenERP
      #
      def remote
        self.class.remote
      end

      def == other
        if new_record?
          false
        else
          self.class === other and id == other.id
        end
      end

      class << self
        def fields_hash
          @fields_hash ||= fields_to_hash(fields_get)
        end

        def fields
          @fields ||= fields_hash.values
        end

        # Send method calls via xmlrpc to OpenERP
        #
        def remote
          @remote ||= database.object oo_name
        end

        protected
        def fields_to_hash fields
          return nil if fields.nil?

          {}.tap do |h|
            fields.each do |field|
              h[field.name] = field
            end
          end
        end
      end
    end
  end
end
