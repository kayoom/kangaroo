require 'kangaroo/model/dynamic_finder'

module Kangaroo
  module Model
    class Relation
      include DynamicFinder
      
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
                            sort_by split sum take take_while tap third to to_ary to_default_s to_enum to_formatted_s to_json to_matcher
                            to_param to_query to_s to_sentence to_set to_xml to_xml_rpc to_yaml to_yaml_properties to_yaml_style transpose
                            type uniq uniq! uniq_by uniq_by! unshift values_at yaml_initialize zip |).freeze

      # @private
      attr_accessor :target,
                    :where_clauses,
                    :offset_clause,
                    :limit_clause,
                    :select_clause,
                    :order_clause,
                    :context_clause,
                    :reverse_flag

      alias_method :_clone, :clone
      alias_method :_tap, :tap

      delegate *(ARRAY_DELEGATES + [:to => :to_a])

      # @private
      def initialize target
        @target     = target
        @where_clauses = []
        @select_clause = []
        @order_clause  = []
        @context_clause = {}
      end

      # Submit the query
      def to_a
        @target.search_and_read @where_clauses, search_parameters, read_parameters
      end
      alias_method :all, :to_a

      # Return only the first record
      def first
        limit(1).to_a.first
      end

      # Return only the last record
      def last
        count = self.count
        offset(count - 1).limit(1).first
      end

      # Check if a record with fulfilling this conditions exist
      def exists?
        @target.search(@where_clauses, search_parameters.merge(:limit => 1)).present?
      end

      # Find record(s) by id(s)
      def find ids
        records = where(:id => ids)

        Array === ids ?
        records.all :
        records.first
      end
      
      def find_in_batches batch_size = 100
        objects_count = count
        batches_count = objects_count / batch_size + 1
        
        objects = []
        batches_count.times do |batch_no|
          objects += limit(batch_size).offset(batch_no * batch_size).all
        end
        
        objects
      end

      # Count how many records fulfill this conditions
      def count
        @target.count_by @where_clauses, search_parameters
      end
      alias_method :size, :count
      alias_method :length, :count

      # Reverse all order clauses
      def reverse
        if @order_clause.blank?
          _clone._tap do |c|
            c.reverse_flag = !c.reverse_flag
          end
        else
          _clone._tap do |c|
            c.reverse_flag = false
            c.order_clause = c.order_clause.map do |order|
              reverse_order order
            end
          end
        end
      end

      # Clone this relation and add the condition to the where clause
      #
      # @param [Hash, Array, String] condition
      # @return [Relation] cloned relation
      def where condition
        _clone._tap do |c|
          c.where_clauses += [condition]
        end
      end

      # Clone this relation and (re)set the limit clause
      #
      # @param [Number] limit maximum records to retriebe
      # @return [Relation] cloned relation
      def limit limit
        _clone._tap do |c|
          c.limit_clause = limit
        end
      end

      # Clone this relation and (re)set the offset clause
      #
      # @param [Number] offset number of records to skip
      # @return [Relation] cloned relation
      def offset offset
        _clone._tap do |c|
          c.offset_clause = offset
        end
      end

      # Clone this relation and add select expressions to select clause
      #
      # @param [Array, String, Symbol] selects fields to retrieve
      # @return [Relation] cloned relation
      def select *selects
        selects = selects.flatten.map &:to_s
        _clone._tap do |c|
          c.select_clause += selects
        end
      end

      # Clone this relation and add a context
      #
      # @param [Hash] context
      # @return [Relation] cloned relation
      def context context = {}
        _clone._tap do |c|
          c.context_clause = c.context_clause.merge(context)
        end
      end

      # Clone this relation and add an order instruction
      #
      # @param [String, Symbol] column field to order by
      # @param [boolean] desc true to order descending
      def order column, desc = false
        column = column.to_s
        column = column + " desc" if desc
        
        _clone._tap do |c|
          c.reverse_flag = true if column.downcase == 'id desc'
          c.order_clause += [column.to_s]
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

        c = _clone

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

      protected
      def search_parameters
        {
          :offset  => @offset_clause,
          :limit   => @limit_clause,
          :order   => @order_clause.join(", "),
          :context => @context_clause
        }
      end

      def read_parameters
        {
          :fields       => @select_clause,
          :context      => @context_clause,
          :reverse_flag => @reverse_flag
        }
      end

      def reverse_order order
        if match = order.match(/(.*)\sdesc/i)
          match[1]
        else
          order + " desc"
        end
      end
    end
  end
end
