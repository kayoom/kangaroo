module Kangaroo
  class Relation
    ARRAY_DELEGATES = %w(each to_a map map!).freeze #TODO extend this list
    attr_accessor :target, :conditions
    
    delegate *(ARRAY_DELEGATES + [:to => :all])
    
    def initialize target
      @target     = target
      @conditions = []
    end
    
    def where condition
      clone.tap do |c|
        c.conditions += [condition]
      end
    end
    
    def all
      @target.all({
        :conditions => conditions
      })
    end
  end
end