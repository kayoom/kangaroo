module Kangaroo
  module Model
    class Relation
      # @private
      ARRAY_DELEGATES = %w( all? any? as_json at b64encode blank? choice class clone collect collect! combination compact compact! concat
                            cycle decode64 delete delete_at delete_if detect drop drop_while dup duplicable? each each_cons each_index
                            each_slice each_with_index each_with_object empty? encode64 encode_json entries enum_cons enum_for enum_slice
                            enum_with_index eql? equal? exclude? extract_options! fetch fifth fill find_all find_index flatten
                            flatten! forty_two fourth freeze frozen? grep group_by html_safe? in_groups in_groups_of include? index
                            index_by indexes indices inject insert inspect instance_eval instance_exec instance_of? is_a? join kind_of?
                            last many? map map! max max_by member? min min_by minmax minmax_by nitems none? one? pack paginate
                            partition permutation pop presence present? pretty_inspect pretty_print pretty_print_cycle pretty_print_inspect
                            pretty_print_instance_variables product push rassoc reduce reject reject! replace respond_to? returning reverse
                            reverse! reverse_each rindex sample second shelljoin shift shuffle shuffle! slice slice! sort sort!
                            sort_by split sum take take_while tap third to to_a to_ary to_default_s to_enum to_formatted_s to_json to_matcher
                            to_param to_query to_s to_sentence to_set to_xml to_xml_rpc to_yaml to_yaml_properties to_yaml_style transpose
                            type uniq uniq! uniq_by uniq_by! unshift values_at yaml_initialize zip |).freeze
      # @private
      BASE_DELEGATES = %w(first find count size length).freeze

      # @private
      attr_accessor :target, :where_clauses, :offset_clause, :limit_clause, :select_clause, :order_clause, :context_clause

      alias_method :__clone__, :clone
      alias_method :__tap__, :tap

      delegate *(ARRAY_DELEGATES + [:to => :all])

      # @private
      def initialize target
        @target     = target
        @where_clauses = []
        @select_clause = []
        @order_clause  = []
        @context_clause = {}
      end

      # DISCUSS
      def all
        @target.execute_query query_parameters
      end

      # Clone this relation and add the condition to the where clause
      #
      # @param [Hash, Array, String] condition
      # @return [Relation] cloned relation
      def where condition
        __clone__.__tap__ do |c|
          c.where_clauses += [condition]
        end
      end

      # Clone this relation and (re)set the limit clause
      #
      # @param [Number] limit maximum records to retriebe
      # @return [Relation] cloned relation
      def limit limit
        __clone__.__tap__ do |c|
          c.limit_clause = limit
        end
      end

      # Clone this relation and (re)set the offset clause
      #
      # @param [Number] offset number of records to skip
      # @return [Relation] cloned relation
      def offset offset
        __clone__.__tap__ do |c|
          c.offset_clause = offset
        end
      end

      # Clone this relation and add select expressions to select clause
      #
      # @param [Array, String, Symbol] selects fields to retrieve
      # @return [Relation] cloned relation
      def select *selects
        selects = selects.flatten.map &:to_s
        __clone__.__tap__ do |c|
          c.select_clause += selects
        end
      end

      # Clone this relation and add a context
      #
      # @param [Hash] context
      # @return [Relation] cloned relation
      def context context = {}
        __clone__.__tap__ do |c|
          c.context_clause = c.context_clause.merge(context)
        end
      end

      # Clone this relation and add an order instruction
      #
      # @param [String, Symbol] column field to order by
      # @param [boolean] desc true to order descending
      def order column, desc = false
        column = column.to_s + " desc" if desc
        __clone__.__tap__ do |c|
          c.order_clause += column.to_s
        end
      end

      # Shortcut to set limit and offset and execute queries immediately.
      # If {#limit} or {#offset} are already set, [] is equal to #to_a[]
      #
      # @overload [](n)
      #   @param [Number] n
      #   @return [Kangaroo::Model::Base] n-th record
      # @overload [](n, m)
      #   @param [Number] n
      #   @param [Number] m
      #   @return [Array<Kangaroo::Model::Base>] m records, offset n
      # @overload [](n..m)
      #   @param [Range] range n..m
      #   @return [Array<Kangaroo::Model::Base>] records m to n
      def [] start_or_range, stop = nil
        if @limit_clause || @offset_clause
          return to_a[start_or_range, stop] if stop
          return to_a[start_or_range]
        end

        c = __clone__

        c.offset_clause = if start_or_range.is_a?(Range)
          range_end = start_or_range.end
          range_end += 1 unless start_or_range.exclude_end?

          c.limit_clause = range_end - start_or_range.begin
          start_or_range.begin
        elsif stop
          c.limit_clause = stop
          start_or_range
        else
          c.limit_clause = 1
          start_or_range
        end

        (stop.nil? && Integer===start_or_range) ? c.to_a.first : c.to_a
      end

      BASE_DELEGATES.each do |delegate|
        define_method delegate do |*args|
          args << query_parameters
          @target.send delegate, *args
        end
      end

      protected
      def query_parameters
        {
          :conditions => @where_clauses,
          :offset => @offset_clause,
          :limit => @limit_clause,
          :select => @select_clause,
          :order => @order_clause,
          :context => @context_clause
        }
      end
    end
  end
end