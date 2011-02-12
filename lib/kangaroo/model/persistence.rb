require 'kangaroo/exception'

module Kangaroo
  module Model
    module Persistence
      # @private
      class InstantiatedRecordNeedsIDError < Kangaroo::Exception ; end

      # @private
      def self.included klass
        klass.extend ClassMethods
        klass.define_model_callbacks :destroy, :save, :update, :create
        klass.after_destroy :mark_destroyed
        klass.after_save :mark_persisted

        klass.send :attr_accessor, :context

        klass.before_initialize do
          @destroyed  = false
          @readonly   = false
          @new_record = !@id
        end
      end

      # Check if this record hasnt been persisted yet
      #
      # @return [boolean] true/false
      def new_record?
        @new_record
      end

      # Check if this record has been persisted yet
      #
      # @return [boolean] true/false
      def persisted?
        !@new_record
      end

      private
      def mark_persisted
        @new_record = false
      end

      def mark_destroyed
        @destroyed = true
        freeze
      end

      module ClassMethods
        def find id
          read([id]).first ||
          raise(RecordNotFound)
        end
        
        protected
        def instantiate attributes, context = {}
          allocate.tap do |instance|
            instance.instance_exec(attributes.stringify_keys, context) do |attributes, context|
              @attributes = attributes.except 'id'
              @id = attributes['id']
              @context = context
              raise InstantiatedRecordNeedsIDError if @id.nil?

              @new_record = false
              @destroyed  = false
              @readonly   = false

              _run_initialize_callbacks
              _run_find_callbacks
            end
          end
        end
      end
    end
  end
end