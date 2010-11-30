module Kangaroo
  class Column
    RELATION_TYPES = %w(many2one one2many many2many one2one).freeze
    attr_accessor :name, :context, :digits, :domain, :fnct_inv, :fnct_inv_arg, :fnct_search, :func_method, :func_obj, :function, :help, 
                  :readonly, :related_columns, :relation, :required, :select, :selectable, :selection, :size, :store, :string, :third_table, 
                  :translate, :states, :change_default, :type, :group_operator, :views
                  
    def initialize name, properties = {}
      @name = name
      
      properties.each do |key, value|
        send "#{key}=", value
      end
    end
                  
    def required?
      !!required
    end
    
    def readonly?
      !!readonly
    end
    
    def relation?
      RELATION_TYPES.include? type
    end
    
    def selection= value
      @selection = Hash[value]
    end
  end
end