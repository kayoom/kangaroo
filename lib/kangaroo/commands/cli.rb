require 'kangaroo/commands/base'
require 'irb'
require 'irb/completion'
require 'hirb'
require 'kangaroo/commands/endpoint'

module IRB
  mattr_accessor :prompt
  
  class << self
    alias init_config_old init_config
  end
  
  def IRB.init_config(ap_path)
    init_config_old ap_path
    @@prompt ||= "kang"
    
    @CONF[:PROMPT] = {
      :CUSTOM => {
        :PROMPT_I => "#{@@prompt} > ",
        :PROMPT_S => "#{@@prompt} %l> ",
        :PROMPT_C => "#{@@prompt} .. ",
        :PROMPT_N => "#{@@prompt} .. ",
        :RETURN => "=> %s\n"
      }
    }
    @CONF[:PROMPT_MODE] = :CUSTOM
    @CONF[:AUTO_INDENT] = true
  end
end


module Kangaroo
  module Commands
    class CLI < Base
      def run
        super
        
        initialize_global_endpoint
        start_irb
      end
      
      protected
      def initialize_global_endpoint
        ::Kang.connect configuration, logger
        ::Kang.load_models!
      end
      
      def start_irb
        ARGV.clear
        
        user = ::Kang.configuration['database']['user']
        db = ::Kang.configuration['database']['name']
        
        IRB.prompt = "#{user}@#{db}"
        ::Hirb.enable
        ::IRB.start
      end
      
      def banner
        "".tap do |s|
          s << 'kang - The Kangaroo command line interface'
          s << ''
          s << 'Usage:'
        end
      end
    end
  end
end
