module Kangaroo
  module Util
    class Loader
      module RootNamespace
        include Namespace
        include InformationRepository
        include Reflection
        
        mattr_accessor :database
        
        # Apply naming convention: convert OpenObject name (e.g. "product.product") to
        # Ruby class name, respecting current namespace (e.g. "Oo::Product::Product")
        def oo_to_ruby oo_name
          name + "::" + oo_name.gsub('.','/').camelize
        end

        # Apply naming convention: convert
        # Ruby class name, respecting current namespace (e.g. "Oo::Product::Product")
        # to OpenObject name (e.g. "product.product")
        def ruby_to_oo ruby_name
           ruby_name.to_s.sub(name + "::",'').underscore.gsub '/', '.'
        end
      end
    end
  end
end