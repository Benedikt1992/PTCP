begin
  require 'colorize'
  require 'slop'
  require 'yaml'
  require 'deep_merge'
  require 'ptcp/util'
rescue LoadError => e
   puts "Couldn't load required Gem: #{e.message.slice!(25..50)}!".red
   exit
end

module PTCP
  #TODO autogenerating config file
  module Settings
    extend self
    CONFIG_FILE = 'config.yaml'

    @_settings = {}
    attr_reader :_settings

    def load filename=nil
      # Load configuration file
      #
      # Informations in the config file:
      #  - cygwin_installation_path: The path to the cygwin-shell (e.g. mintty)
      #  - ssh_client: The path to the openssh like ssh Client programm (default: '/usr/bin/ssh')
      #  - detach_childprocesses: Yes|No, Default: No, Determine if child processes schould be detached from this programm or if the programm should wait for the child processes.
      if filename
        config = YAML.load_file(filename).symbolize_keys!
      else
        raise IOError ,"Config file not found. Please place it into '#{default_config_path}'".red if not(File.exists?(default_config_path))
        config = YAML.load_file(default_config_path).symbolize_keys!
      end

      # Defaults
      config[:ssh_client] = '/usr/bin/ssh' if not config[:ssh_client]

      @_settings.deep_merge!(config)
    end

    def method_missing(name, *args, &block)
      @_settings[name.to_sym] ||
        raise(NoMethodError, "unknown configuration root #{name}", caller)
    end

    #TODO include the cli options into the settings module attribute
    def parse_cli_options
      # Original Manual http://tartarus.org/~simon/putty-snapshots/htmldoc/Chapter3.html#using-cmdline

      # Parse the parameters from commandline
      # Definition of options
      #TODO Copyright informations with link and auto completion
      #TODO Hidden Options User and Host
      opts = Slop::Options.new
      opts.banner = "Usage: puttytocygwinproxy.rb [options] [user@]host"
      opts.separator ""
      opts.separator "Options:"
      opts.bool '-ssh', '--ssh-protocol', 'selects the SSH protocol (default)'
      opts.bool '-telnet', '--telnet-protocol', 'selects the Telnet protocol'
      opts.bool '-rlogin', '--rlogin-protocol', 'selects the Rlogin protocol'
      opts.bool '-raw', '--raw-protocol', 'selects the raw protocol'
      opts.string '-serial', '--serial-protocol', 'selects a serial connection'
      opts.separator ""
      opts.bool '-v', '--verbose', 'Increase verbosity'
      opts.string '-u', '--user', 'User'
      opts.string '-h', '--host', 'Host'
      opts.on '--help' do
        puts opts
        exit
      end

      # Parse options
      begin
        parser = Slop::Parser.new(opts)
        result = parser.parse(ARGV)

        user_host = result.arguments.join('%')
        result[:user] = user_host.slice(/(^[^%]+(?=@))|((?<=%).*(?=@))/) if not result[:user]       # Match everything before @. Start at ^ or %
        result[:host] = user_host.slice(/(?<=@).*(?=%)|(?<=@)[^%]+$|^[^%@]+$/) if not result[:host] # Match everything after @. Stop at $ or %. Or Catch everything (only one string allowed!)

        # Validation
        raise ArgumentError, "Couldn't detect Host. Use '--help' for more information. The following Arguments were received: '#{ARGV.join(' ')}'".red if not result[:host]

      rescue Slop::UnknownOption => e
        puts "The Option '#{e.flag}' is unkown. Use '--help' for more information.".red
        exit

      rescue Slop::MissingArgument => e
        puts "There was no Argument specified for the option '#{e.flags.join(', ')}'. Use '--help' for more information.".red
        exit

      end

      result
    end

    def default_config_path
      return "#{ENV['localappdata'].gsub(/\\/,'/')}/ptcp/config.yml" if PTCP::Util::OS.is_windows?
      '/etc/ptcp/config.yml'
    end
  end
end
