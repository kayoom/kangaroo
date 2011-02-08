require 'rubygems'
require 'rapuncel'
require 'active_support/core_ext/string'
require "xmlrpc/server"
require 'webrick'

module TestServices
  class ObjectService
    def execute *args
      xmlrpc_call 'execute', *args
    end

    protected
    def xmlrpc_call name, *args
    end
  end

  class CommonService
    def login *args
      xmlrpc_call 'login', *args
      args
    end

    def some_method *args
      xmlrpc_call 'some_method', *args
      args
    end

    protected
    def xmlrpc_call name, *args
    end
  end

  class DbService
    def list *args
      xmlrpc_call 'list', *args
      args
    end

    def rename *args
      xmlrpc_call 'rename', *args
      args
    end

    protected
    def xmlrpc_call name, *args
    end
  end

  class ReportService
    def create *args
      xmlrpc_call 'create', *args
      args
    end

    protected
    def xmlrpc_call name, *args
    end
  end

  class WizardService
    def create *args
      xmlrpc_call 'create', *args
    end

    protected
    def xmlrpc_call name, *args
    end
  end
end

module TestServerHelper
  def self.included klass
    klass.before :all do
      @test_server = TestServer.start
    end

    klass.after :all do
      @test_server.stop
    end
  end

  def client service
    Rapuncel::Client.new :host => '127.0.0.1', :port => 8069, :path => "/xmlrpc/#{service}"
  end

  def proxy service, *args
    Kangaroo::Util::Proxy.const_get(service.camelize).new client(service), *args
  end

  def object_service
    @test_server.object_service
  end

  def common_service
    @test_server.common_service
  end

  def db_service
    @test_server.db_service
  end

  def report_service
    @test_server.report_service
  end

  def wizard_service
    @test_server.wizard_service
  end
end

class TestServer
  SERVICES = %w(ObjectService CommonService DbService WizardService ReportService)
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