require 'kangaroo/model/relation'
require 'kangaroo/model/attributes'
require 'kangaroo/model/default_attributes'
require 'kangaroo/model/inspector'
require 'kangaroo/model/persistence'
require 'kangaroo/model/open_object_orm'
require 'kangaroo/model/finder'
require 'kangaroo/model/remote_execute'
require 'kangaroo/model/validations'
require 'active_model/callbacks'
require 'active_support/core_ext/class'

module Kangaroo
  module Model
    class Base
      class_attribute :database
      class_inheritable_array :field_names

      extend ActiveModel::Callbacks
      define_model_callbacks :initialize

      include Attributes
      include Persistence
      include DefaultAttributes
      include Inspector
      extend OpenObjectOrm
      extend Finder
      include RemoteExecute

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

      class << self
        def fields
          @fields ||= fields_get
        end
        
        def namespace
          ("::" + name.match(/^(?:\:\:)?([^\:]+)/)[1]).constantize
        end
        
        # Return this models OpenObject name
        def oo_name
          namespace.ruby_to_oo self.name
        end

        # Send method calls via xmlrpc to OpenERP
        #
        def remote
          @remote ||= database.object oo_name
        end
      end
    end
  end
end