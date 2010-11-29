module Kangaroo
  class Relation
    ARRAY_DELEGATES = %w(each to_a map map!).freeze #TODO extend this list
    attr_accessor :target, :where_clauses, :offset_clause, :limit_clause
    
    delegate *(ARRAY_DELEGATES + [:to => :all])
    
    def initialize target
      @target     = target
      @where_clauses = []
    end
    
    def where condition
      clone.tap do |c|
        c.where_clauses += [condition]
      end
    end
    
    def limit limit
      clone.tap do |c|
        c.limit_clause = limit
      end
    end
    
    def offset offset
      clone.tap do |c|
        c.offset_clause = offset
      end
    end
    
    def all
      @target.all({
        :conditions => @where_clauses,
        :offset => @offset_clause,
        :limit => @limit_clause
      })
    end
  end
end