module Kangaroo
  class Exception < ::Exception ; end
  class RecordNotFound < Exception ; end
  class RecordSavingFailed < Exception ; end
end