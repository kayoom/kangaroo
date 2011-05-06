require 'kangaroo/util/configuration'
require 'kangaroo/model/base'
require 'kangaroo/hirb'

module Kangaroo
end

require 'kangaroo/railtie' if defined?(Rails)
