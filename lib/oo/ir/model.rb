module Oo
  module Ir
    class Model < Kangaroo::Base
      define_attribute_methods :state, :osv_memory, :name, :model, :info, :field_id, :access_ids
      
    end
  end
end

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
