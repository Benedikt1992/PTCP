require "ptcp/version"
require 'ptcp/settings'
require 'ptcp/extensions'
require 'ptcp/util'
require 'colorize'

module PTCP
  extend self

  def start
    PTCP::Settings.load

    # Original Manual http://tartarus.org/~simon/putty-snapshots/htmldoc/Chapter3.html#using-cmdline

    # Parse the parameters from commandline
    result = PTCP::Settings.parse_cli_options
    user = result[:user]
    host = result[:host]
    #puts result[:H] #=> { hostname: "192.168.0.1", port: 80,
    #                 #     files: [], verbose: false }
    #
    #puts opts # prints out help

    # Default case: ssh
    if user and host
      puts "start ssh session with #{PTCP::Settings.cygwin_installation_path} #{PTCP::Settings.ssh_client} #{user}@#{host}" if result[:verbose]
      pid = Process.spawn("#{PTCP::Settings.cygwin_installation_path} #{PTCP::Settings.ssh_client} #{user}@#{host}")
      puts "Babun started with pid #{pid}" if result[:verbose]
      if PTCP::Settings.detach_childprocesses
        Process.detach(pid)
      else
        Process.wait pid
      end
    else
      puts "start ssh session with #{PTCP::Settings.cygwin_installation_path} #{PTCP::Settings.ssh_client} #{host}" if result[:verbose]
      pid = Process.spawn("#{PTCP::Settings.cygwin_installation_path} #{PTCP::Settings.ssh_client} #{host}")
      puts "Babun started with pid #{pid}" if result[:verbose]
      Process.detach(pid)
    end
  end
end
