require "ptcp/version"
require 'ptcp/settings'
require 'ptcp/extensions'
require 'ptcp/util'
require 'ptcp/connections'
require 'colorize'

module PTCP
  extend self

  def start
    # Parse the parameters from commandline
    PTCP::Settings.parse_cli_options
    PTCP::Settings.load PTCP::Settings.config_file
    # Original Manual http://tartarus.org/~simon/putty-snapshots/htmldoc/Chapter3.html#using-cmdline

    user = PTCP::Settings.user
    host = PTCP::Settings.host
    #puts result[:H] #=> { hostname: "192.168.0.1", port: 80,
    #                 #     files: [], verbose: false }
    #
    #puts opts # prints out help

    # Default case: ssh

    connection ||= PTCP::Settings.ssh ? :ssh.id2name : nil
    connection ||= PTCP::Settings.telnet ? :telnet.id2name : nil
    pid = PTCP::Connections[connection].start

    if PTCP::Settings.detach_childprocesses
      Process.detach(pid)
    else
      Process.wait pid
    end
  end
end
