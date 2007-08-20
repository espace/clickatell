require 'optparse'
require 'ostruct'

module Clickatell
  module Utility
    class Options #:nodoc:
      def self.parse(args)
        options = self.default_options
        parser = OptionParser.new do |opts|
          opts.banner = "Usage: sms [options] recipient_number message"
          opts.separator ""
          opts.separator "Specific options:"
          
          opts.on('-u', '--username [USERNAME]',
            "Specify the clickatell username (overrides ~/.clickatell setting)") do |username|
             options.username = username 
          end
          
          opts.on('-p', '--password [PASSWORD]',
            "Specify the clickatell password (overrides ~/.clickatell setting)") do |password|
             options.password = password
          end
          
          opts.on('-k', '--apikey [API_KEY]',
            "Specify the clickatell API key (overrides ~/.clickatell setting)") do |key|
             options.api_key = key
          end
          
          opts.on_tail('-h', '--help', "Show this message") do
            puts opts
            exit
          end
          
          opts.on_tail('-v', '--version') do
            puts "Ruby Clickatell SMS Utility #{Clickatell::VERSION}"
            exit
          end
        end
        
        parser.parse!(args)
        options.recipient = ARGV[-2]
        options.message   = ARGV[-1]
        return options
      end
      
      def self.default_options
        options = OpenStruct.new
        config_file = File.open(File.join(ENV['HOME'], '.clickatell'))
        config = YAML.load(config_file)
        options.username = config['username']
        options.password = config['password']
        options.api_key  = config['api_key']
        return options
      rescue Errno::ENOENT
        return options
      end
    end
  end
end
