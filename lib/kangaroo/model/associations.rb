module Kangaroo
  module Model
    module Associations
      extend ActiveSupport::Concern
      
      autoload :Many2one, 'kangaroo/model/associations/many2one'
      autoload :One2many, 'kangaroo/model/associations/one2many'
      
      Types = %w(many2one one2many).freeze
      
      included do
        include Many2one
        include One2many
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