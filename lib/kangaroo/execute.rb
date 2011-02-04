module Kangaroo
  module Execute
    def self.included base
      base.send :extend, ClassMethods
    end
    
    def execute name, *args
      ids = new_record? ? [] : [id]
      args.unshift ids
      values = self.class.execute name, *args
      
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
    
    module ClassMethods
      def execute name, *args
        database.execute self, name, *args        
      end
    end
  end
end
