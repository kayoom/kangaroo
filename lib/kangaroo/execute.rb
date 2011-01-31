module Kangaroo
  module Execute
    def execute name, *args
      ids = new_record? ? [] : [id]
      values = database.execute self.class, name, ids, *args
      values = values[:value]
      
      if values.is_a?(Hash)
        values.keys.each do |key|
          attribute_will_change! key
        end
        @attributes.merge! values.stringify_keys
      end
      
      values
    end
    
    protected
    def method_missing name, *args
      execute name, *args
    rescue
      super
    end
  end
end
