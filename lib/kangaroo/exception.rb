module Kangaroo
  class Exception < ::Exception ; end
  class RecordNotFound < Exception ; end
  class RecordSavingFailed < Exception ; end
  class InstantiatedRecordNeedsIDError < Exception ; end
  class ChildDefinedBeforeParentError < Exception ; end
end