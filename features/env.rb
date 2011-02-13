require 'rubygems'
require 'bundler/setup'

require 'rspec/expectations'
require 'cucumber/rspec/doubles'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w(.. .. lib)))
require 'kangaroo'