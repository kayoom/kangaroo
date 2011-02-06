module Kangaroo
  module RubyAdapter
    class Exception < ::Exception ; end
    class ChildDefinedBeforeParentError < Exception ; end
  end
end