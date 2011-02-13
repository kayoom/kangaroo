Given /^i have a configuration file$/ do
  @config_hash = YAML.load "features/support/test.yml"
end

When /^i setup a configuration$/ do
  @logger = Logger.new(STDERR)
  @config = Kangaroo::Util::Configuration.new @config_hash, @logger
end

Then /^i should be able to login$/ do
  @logger.should_not_receive :warn
  @config.login
end
