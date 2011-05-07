module Kangaroo
  module Model
    module DataImport
      def import_all records, options = {}
        fields = changed_fields_in records
        datas = map_fields_in records, fields
        
        fields << '.id'
        import_data fields, datas, options
      end
      
      protected
      def changed_fields_in records
        records.sum([]) do |record|
          record.changed
        end.uniq
      end
      
      def map_fields_in records, fields
        records.map do |record|
          fields.map do |field|
            record.read_attribute field
          end + [record.id]
        end
      end
    end
  end
end