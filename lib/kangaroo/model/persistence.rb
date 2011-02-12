require 'kangaroo/exception'
require 'active_support/core_ext/hash'

module Kangaroo
  module Model
    module Persistence
      # @private
      class InstantiatedRecordNeedsIDError < Kangaroo::Exception ; end

      # @private
      def self.included klass
        klass.extend ClassMethods
        klass.define_model_callbacks :destroy, :save, :update, :create, :find
        klass.after_destroy :mark_destroyed
        klass.after_create :mark_persisted
        klass.after_save :reload

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
      
      # Check if this record has been destroyed
      #
      # @return [boolean] true/false
      def destroyed?
        @destroyed
      end
      
      # Destroy this record
      #
      # @return self
      def destroy
        _run_destroy_callbacks do
          remote.unlink [id], :context => context
        end
        
        self
      end
      
      # Save this record
      #
      # @param [Hash] options unused
      # @return [boolean] true/false
      def save options = {}
        create_or_update
      end
      
      # Save this record or raise an error
      #
      # @param [Hash] options unused
      # @return [boolean] true
      def save! options = {}
        save options || 
        raise(RecordSavingFailed)
      end
      
      # Reload this record, or just a subset of fields
      #
      # @param [Array] fields to reload
      # @return self
      def reload fields = self.class.attribute_names
        @attributes = remote.read([id], fields, context).first.except(:id).stringify_keys
        fields.each do |field|
          @changed_attributes.delete field.to_s
        end
        
        self
      end
      
      module ClassMethods
        # Initialize a record and immediately save it
        #
        # @param [Hash] attributes
        # @return saved record
        def create attributes = {}
          new(attributes).tap do |new_record|
            new_record.save
          end
        end
        
        # Retrieve a record by id
        #
        # @param [Number] id
        # @return record
        # @raise RecordNotFound
        def find id
          Array === id ?
          find_every(ids) :
          find_single(id)
        end
        
        protected
        def find_single id
          read([id]).first ||
          raise(RecordNotFound)
        end
        
        def find_every ids
          read ids
        end
        
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
      
      protected
      def attributes_for_update
        @attributes
      end
      
      def attributes_for_create
        @attributes
      end
      
      def create_or_update
        new_record? ? create : update
      end
      
      private
      def create
        _run_create_callbacks do
          if id = self.class.create_record(attributes_for_create, :context => context)
            @id = id
          else
            false
          end
        end
      end
      
      def update
        _run_update_callbacks do
          self.class.write_record [id], attributes_for_update, :context => context
        end
      end
      
      def mark_persisted
        @new_record = false
      end

      def mark_destroyed
        @destroyed = true
        freeze
      end
    end
  end
end