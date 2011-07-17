require 'kangaroo/doc/namespace'

module Kangaroo
  module Doc
    class Klass < Namespace
      def register
        nspace = register_with_yard 'class', name do |r|
          mixin_i = P('Kangaroo::Util::Loader::Model')
          r.mixins(:instance).unshift(mixin_i) unless r.mixins(:instance).include?(mixin_i)
          
          mixin_c = P('Kangaroo::Util::Loader::Model::ClassMethods')
          r.mixins(:class).unshift(mixin_c) unless r.mixins(:class).include?(mixin_c)
        end
        
        register_namespaces_or_models_in
      end
    end
  end
end