lib_dir = File.join File.dirname(__FILE__), '..', 'lib'
$:.unshift lib_dir

require 'rubygems'
require 'active_support/all'
require 'test/unit'
require 'rapuncel'
require 'active_model'
require 'kangaroo'
