require 'rubygems'
require 'rapuncel'
require 'active_support/core_ext/string'
require "xmlrpc/server"
require 'webrick'

module TestServices
  class ObjectService
    def execute *args
      xmlrpc_call 'execute', *args
      args
    end
    
    protected
    def xmlrpc_call name, *args
    end
  end
  
  class CommonService
    def login *args
      args
    end
  end
end

class TestServer
  SERVICES = %w(ObjectService CommonService)
  SERVICES.each do |service|
    attr_accessor service.underscore
  end
  attr_accessor :server
  
  def initialize    
    @server = WEBrick::HTTPServer.new(:Port => 8069, :BindAddress => '127.0.0.1', :MaxClients => 1, 
                                      :Logger => WEBrick::Log.new(File.open('/dev/null', 'w')))

    SERVICES.each do |service|
      mount_service service
    end
  end
  
  def serve
    if RUBY_PLATFORM =~ /mingw|mswin32/
      signals = [1]
    else
      signals = %w[INT TERM HUP]
    end
    signals.each { |signal| trap(signal) { @server.shutdown } }

    @server.start
  end
  
  def mount_service service
    server = XMLRPC::WEBrickServlet.new ''
    add_handler server, service
    @server.mount "/xmlrpc/#{mount_point(service)}", server
  end
  
  def mount_point service
    service.underscore.sub '_service', ''
  end
  
  def add_handler server, service
    const = "TestServices::#{service}".constantize
    inst = const.new
    send "#{service.underscore}=", inst
    server.add_handler(XMLRPC::iPIMethods(''), inst)
  end
  
  def check
    client = Rapuncel::Client.new :port => 8069, :path => '/xmlrpc/object'
    client.proxy.execute *%w(a b c d)
  end

  def stop
    @server.shutdown
  end
  
  def self.start
    new.tap do |s|
      Thread.new do
        s.serve
      end
    end
  end
end