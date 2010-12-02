module Kangaroo
  class Column
    class Association
      TYPES = %w(many2one one2many many2many one2one).freeze
      attr_accessor :target, :conditions, :related_columns
      attr_reader :type, :field
      
      def name
        @name ||= case type.last
        when 'many'
          field.sub(/_ids?\Z/,'').pluralize
        when 'one'
          field.sub(/_ids?\Z/,'').singularize
        end
      end
      
      def id_name
        @id_name ||= name.singularize + ((type.last == 'many') ? "_ids" : "_id")
      end
      
      def joined?
        ['many', 'many'] == type
      end
      
      def property?
        field.starts_with? 'property_'
      end
      
      def field= field
        @field = field.to_s
      end
      
      def target_class_name
        @target_class_name ||= Oo.oo_name_to_ruby target
      end
      
      def type= type
        @type = type.match(/\A(.*)2(.*)\Z/).captures
      end
    end
    
    class Selection
      attr_accessor :type, :options, :implicit_target, :implicit_domain
      
      delegate :keys, :values, :to => :options
      def init_options options_array
        @options = ActiveSupport::OrderedHash.new.tap do |h|
          options_array.each do |key_val|
            key, val = key_val
          
            h[key] = val unless key.blank? || val.blank?
          end
        end
      end
    end
    
    attr_accessor :name, :context, :digits, :fnct_inv, :fnct_inv_arg, :fnct_search, :func_method, :func_obj, :function, :help, 
                  :readonly, :required, :select, :selectable, :size, :store, :string, :third_table, 
                  :translate, :states, :change_default, :type, :group_operator
                  
    attr_accessor :association, :selection
                  
    def initialize name, properties = {}
      @name = name
      @type = properties.delete :type
      properties.delete :views            
      
      init_selection properties if properties[:selection]
      init_association properties if Association::TYPES.include?(type)
      
      properties.each do |key, value|
        acc = "#{key}="
        send acc, value if respond_to?(acc)
      end
    end
                  
    def required?
      !!required
    end
    
    def readonly?
      !!readonly
    end
    
    def association?
      !!association
    end
    
    def selection?
      !!selection
    end
    
    protected
    def init_selection properties
      @selection = Selection.new.tap do |s|
        s.type = (type == 'selection') ? 'selection' : 'association'
        s.init_options properties.delete :selection
      end
    end
    
    def init_association properties
      @association = Association.new.tap do |a|
        a.target = properties.delete :relation
        a.conditions = properties.delete(:domain) || []
        a.type = @type
        a.field = @name
        a.related_columns = properties.delete :related_columns
      end
    end
  end
end