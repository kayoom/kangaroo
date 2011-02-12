require 'kangaroo'

c = Kangaroo::Util::Configuration.new 'spec/test_env/test.yml'

module Oo::Res
  class Country < Kangaroo::Model::Base
    define_multiple_accessors :code, :name
  end
end

c.login
Oo::Res::Country.database = c.database

