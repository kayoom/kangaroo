module Kangaroo
  module Model
    module Associations
      Types = %w(many2one one2many).freeze
      extend ActiveSupport::Concern
   
      included do
      end
      
      def id_for_associated field
        send(field).first
      end
      
      def name_for_associated field
        send(field).last
      end
      
      module ClassMethods
        def association_fields
          @association_fields ||= fields.select do |field|
            Types.include? field.type
          end
        end
      end
    end
  end
end