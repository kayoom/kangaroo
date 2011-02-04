module Kangaroo
  module Execute
    def execute name, *args
      ids = new_record? ? [] : [id]
      values = database.execute self.class, name, ids, *args
      
      if values.is_a?(Hash) && values[:value]
        values[:value].keys.each do |key|
          attribute_will_change! key
        end
        @attributes.merge! values[:value].stringify_keys
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
