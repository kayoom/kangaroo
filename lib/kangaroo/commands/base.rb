require 'optparse'
require 'highline/import'

module Kangaroo
  module Commands
    class Base
      attr_reader :configuration
      
      def initialize *args
        @configuration = Kangaroo::Util::Configuration::Defaults.dup
        
        parse_options args
      end
      
      def run
        validate_configuration
      end
      
      protected
      def validate_configuration
        unless database_configuration['name']
          puts "Which database do you want to use?"
          printf '> '
          database_configuration['name'] = gets.strip
        end
        
        unless database_configuration['user']
          puts "What's your username at '#{database_configuration['user']}'?"
          printf '> '
          database_configuration['user'] = gets.strip
        end
        
        unless database_configuration['password']
          puts "Type your password"
          database_configuration['password'] = ask('> ') {|q| q.echo = false}.strip
        end
      end
      
      def database_configuration
        configuration['database'] ||= {}
      end
      
      def logger
        @logger ||= Logger.new STDOUT
      end
      
      def parse_options args
        option_parser.parse! args
      end
      
      def banner
        "Usage:"
      end
      
      def option_parser
        @option_parser ||= OptionParser.new do |p|
          p.banner = banner
          
          setup_options p
        end
      end
      
      def set_config file
        file_options = YAML.load_file file
        @configuration = file_options
      end
      
      def set_user user
        database_configuration['user'] = user
      end
      
      def set_password password
        database_configuration['password'] = password
      end
      
      def set_database name
        database_configuration['name'] = name
      end
      
      def set_namespace namespace
        database_configuration['namespace'] = namespace
      end
      
      def set_host host
        configuration['host'] = host
      end
      
      def set_port port
        configuration['port'] = port
      end
      
      def set_help *_
        puts option_parser
        exit
      end
      
      def setup_options p
        setup_option p, '--help', "Display this help screen"
        setup_option p, '--config FILE', 'Specify a configuration file'
        setup_option p, '--user USER', 'Set user to use to login to OpenERP, must be a valid OpenERP user with sufficient privileges'
        setup_option p, '--password PASSWORD', 'Set password for user'
        setup_option p, '--host HOST', 'Set hostname (default: localhost)'
        setup_option p, '--port PORT', 'Set port (default: 8069)', '-i'
        setup_option p, '--database DATABASE', 'Set name of database to use'
        setup_option p, '--namespace NAMESPACE', 'Set namespace / root module to use for models (default: Oo)'
      end
      
      def setup_option p, param, desc = '', short = nil
        param = param.to_s
        short ||= param.match(/^-(-\w)\w*/)[1]
        meth_name = param.match(/^--(\w+)/)[1]
        
        p.on short, param, desc, &method("set_#{meth_name}".to_sym)
      end
    end
  end
end
