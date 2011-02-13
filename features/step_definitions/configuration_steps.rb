Given /^i have a configuration file$/ do
  @config_hash = YAML.load "features/support/test.yml"
end

When /^i setup a configuration$/ do
  @logger = Logger.new(File.open("/dev/null", 'w'))
  @config = Kangaroo::Util::Configuration.new @config_hash, @logger
end

Then /^i should be able to login$/ do
  @logger.should_not_receive :warn
  @config.login
end

When /^i load models matching "([^"]*)"$/ do |arg1|
  Kangaroo::Util::Loader.new('res.*', @config.database).load!
end

Then /^"([^"]*)" should be defined$/ do |arg1|
  lambda { arg1.constantize }.should_not raise_error
end
