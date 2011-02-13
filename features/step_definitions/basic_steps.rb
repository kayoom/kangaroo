Given /^i'm connected to an OpenERP server$/ do
  logger = Logger.new(File.open("/dev/null", 'w'))
  @config = Kangaroo::Util::Configuration.new 'features/support/test.yml', logger
  @config.login
end

When /^i call (.*)\.(.*)$/ do |service, method|
  proxy = Kangaroo::Util::Proxy.const_get(service.camelize).new @config.client.send("#{service}_service")
  @result = proxy.__send__ method
end

Then /^i should see "([^"]*)"$/ do |arg1|
  @result.should include(arg1)
end

Then /^the list should include "([^"]*)"$/ do |arg1|
  @result.flatten.join("\n").should include(arg1)
end
