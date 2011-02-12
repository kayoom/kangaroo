module Kangaroo
  module Util
    class Loader
      module Namespace
        def oo_to_ruby oo_name
          name + "::" + oo_name.gsub('.','/').camelize
        end

        def ruby_to_oo ruby_name
           ruby_name.sub(name + "::",'').underscore.gsub '/', '.'
        end
      end
    end
  end
end