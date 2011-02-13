Given /^i'm connected to an OpenERP server$/ do
  logger = Logger.new(File.open("/dev/null", 'w'))
  @config = Kangaroo::Util::Configuration.new 'features/support/test.yml', logger
  @config.login
end

Given /^setup a proxy to "([^"]*)"$/ do |service|  
  proxy = Kangaroo::Util::Proxy.const_get(service.camelize).new @config.client.send("#{service}_service")
  self.instance_variable_set "@#{service}", proxy
end

When /^i call (.*)\.(.*)$/ do |service, method|
  proxy = instance_variable_get "@#{service}"
  @result = proxy.__send__ method
  puts @result.inspect
end

Then /^i should see "([^"]*)"$/ do |arg1|
  @result.should include(arg1)
end

Then /^the list should include "([^"]*)"$/ do |arg1|
  @result.flatten.join("\n").should include(arg1)
end
