module Kangaroo
  class Relation
    attr_accessor :target, :conditions
    
    def initialize target
      @target     = target
      @conditions = []
    end
    
    def where condition
      clone.tap do |c|
        c.conditions += [condition]
      end
    end
  end
end