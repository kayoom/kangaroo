require 'kangaroo/model_class_creator'

module Oo
  module Ir
    class Model < Kangaroo::Base
      define_attribute_methods :state, :osv_memory, :name, :model, :info, :field_id, :access_ids
      
      def fields
        @fields ||= Fields.using(database).find field_id
      end
      
      def required_fields
        fields.select do |field|
          field.required?
        end
      end
      
      def model_class
        @model_class ||= model_class_name.constantize
      end
      
      def model_class_name
        "Oo::" + model.gsub('.','/').camelize
      end
      
      def create_class
        @model_class ||= Kangaroo::ModelClassCreator.new(self).create
      end
    end
  end
end

require 'oo/ir/model/fields'
require 'oo/ir/model/data'
# { :access_ids 
#     =>{:type=>"one2many", :relation=>"ir.model.access", :string=>"Access", :selectable=>true, :context=>{}, :domain=>[]}, 
#   :field_id
#     =>{:type=>"one2many", :relation=>"ir.model.fields", :string=>"Fields", :selectable=>true, :context=>{}, :required=>true, :domain=>[]}, 
#   :info
#     =>{:type=>"text", :string=>"Information", :selectable=>true}, 
#   :model
#     =>{:type=>"char", :select=>1, :string=>"Object", :selectable=>true, :required=>true, :size=>64}, 
#   :name
#     =>{:type=>"char", :string=>"Object Name", :selectable=>true, :required=>true, :size=>64, :translate=>true}, 
#   :osv_memory
#     =>{:type=>"boolean", :fnct_inv=>false, :fnct_inv_arg=>false, :string=>"In-memory model", :selectable=>true, :fnct_search=>"_search_osv_memory", :readonly=>1, :digits=>[16, 2], :help=>"Indicates whether this object model lives in memory only, i.e. is not persisted (osv.osv_memory)", :func_obj=>false, :function=>"_is_osv_memory", :func_method=>true, :store=>false}, 
#   :state
#     =>{:type=>"selection", :string=>"Type", :selectable=>true, :readonly=>true, :selection=>[["manual", "Custom Object"], ["base", "Base Object"]]}
# } 

 # => {:ttype=>{:type=>"selection", :string=>"Field Type", :required=>true, :selection=>[["reference", "reference"], ["integer", "integer"], ["datetime", "datetime"], ["integer_big", "integer_big"], ["many2many", "many2many"], ["boolean", "boolean"], ["binary", "binary"], ["one2many", "one2many"], ["float", "float"], ["char", "char"], ["selection", "selection"], ["many2one", "many2one"], ["date", "date"], ["text", "text"]], :size=>64, :selectable=>true},
 # :relation=>{:type=>"char", :string=>"Object Relation", :size=>64, :selectable=>true},
 # :relation_field=>{:type=>"char", :string=>"Relation Field", :size=>64, :selectable=>true},
 # :readonly=>{:type=>"boolean", :string=>"Readonly", :selectable=>true},
 # :required=>{:type=>"boolean", :string=>"Required", :selectable=>true},
 # :model_id=>{:type=>"many2one", :select=>true, :relation=>"ir.model", :string=>"Object ID", :context=>{},
 # :required=>true, :selectable=>true, :domain=>[]},
 # :complete_name=>{:type=>"char", :select=>1, :string=>"Complete Name", :size=>64, :selectable=>true},
 # :selection=>{:type=>"char", :string=>"Field Selection", :size=>128, :selectable=>true},
 # :select_level=>{:type=>"selection", :string=>"Searchable", :required=>true, :selection=>[["0", "Not Searchable"], ["1", "Always Searchable"], ["2", "Advanced Search"]], :selectable=>true},
 # :size=>{:type=>"integer", :string=>"Size", :selectable=>true},
 # :selectable=>{:type=>"boolean", :string=>"Selectable", :selectable=>true},
 # :model=>{:type=>"char", :select=>1, :string=>"Object Name", :required=>true, :size=>64, :selectable=>true},
 # :on_delete=>{:type=>"selection", :string=>"On delete", :help=>"On delete property for many2one fields", :selection=>[["cascade", "Cascade"], ["set null", "Set NULL"]], :selectable=>true},
 # :name=>{:type=>"char", :select=>1, :string=>"Name", :required=>true, :size=>64, :selectable=>true},
 # :field_description=>{:type=>"char", :string=>"Field Label", :required=>true, :size=>256, :selectable=>true},
 # :groups=>{:type=>"many2many", :related_columns=>["field_id", "group_id"], :relation=>"res.groups", :third_table=>"ir_model_fields_group_rel", :string=>"Groups", :context=>{},
 # :selectable=>true, :domain=>[]},
 # :translate=>{:type=>"boolean", :string=>"Translate", :selectable=>true},
 # :view_load=>{:type=>"boolean", :string=>"View Auto-Load", :selectable=>true},
 # :state=>{:type=>"selection", :select=>1, :string=>"Type", :readonly=>true, :required=>true, :selection=>[["manual", "Custom Field"], ["base", "Base Field"]], :selectable=>true},
 # :domain=>{:type=>"char", :string=>"Domain", :size=>256, :selectable=>true}} 
