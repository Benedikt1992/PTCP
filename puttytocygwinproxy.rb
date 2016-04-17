#!/usr/bin/env ruby

begin
  require 'colorize'
  require 'pp'

  # Custom modules and classes
  require_relative 'configuration'
rescue LoadError => e
   puts "Couldn't load required Gem: #{e.message.slice!(25..50)}!".red
   exit
end

# Load configuration file
config = Configuration.load

# Original Manual http://tartarus.org/~simon/putty-snapshots/htmldoc/Chapter3.html#using-cmdline

# Parse the parameters from commandline
result = Configuration.parse_cli_options
user = result[:user]
host = result[:host]
#puts result[:H] #=> { hostname: "192.168.0.1", port: 80,
#                 #     files: [], verbose: false }
#
#puts opts # prints out help

# Default case: ssh
if user and host
  puts "start ssh session with #{config["cygwin_installation_path"]} #{config["ssh_client"]} #{user}@#{host}" if result[:verbose]
  pid = Process.spawn("#{config["cygwin_installation_path"]} #{config["ssh_client"]} #{user}@#{host}")
  puts "Babun started with pid #{pid}" if result[:verbose]
  if config["detach_childprocesses"]
    Process.detach(pid)
  else
    Process.wait pid
  end
else
  puts "start ssh session with #{config["cygwin_installation_path"]} #{config["ssh_client"]} #{host}" if result[:verbose]
  pid = Process.spawn("#{config["cygwin_installation_path"]} #{config["ssh_client"]} #{host}")
  puts "Babun started with pid #{pid}" if result[:verbose]
  Process.detach(pid)
end
