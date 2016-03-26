#!/usr/bin/env ruby

begin
  require 'colorize'
  require 'pp'
  require 'slop'
  require 'yaml'
rescue LoadError => e
   puts "Couldn't load required Gem: #{e.message.slice!(25..50)}!".red
   exit
end
raise IOError ,"Config file not found. Please place the file \"config.yaml\" into #{Dir.pwd}".red if not(File.exists?("config.yaml"))
config = YAML.load_file("config.yaml")

# Original Manual http://tartarus.org/~simon/putty-snapshots/htmldoc/Chapter3.html#using-cmdline

# Parse the parameters from commandline
# Definition of options
#TODO Copyright informations with link and auto completion
opts = Slop::Options.new
opts.banner = "Usage: puttytocygwinproxy.rb [options]"
opts.separator ""
opts.separator "Options:"
opts.bool '-ssh', '--ssh-protocol', 'selects the SSH protocol (default)'
opts.bool '-telnet', '--telnet-protocol', 'selects the Telnet protocol'
opts.bool '-rlogin', '--rlogin-protocol', 'selects the Rlogin protocol'
opts.bool '-raw', '--raw-protocol', 'selects the raw protocol'
opts.string '-serial', '--serial-protocol', 'selects a serial connection'
opts.separator ""
opts.bool '-v', '--verbose', 'Increase verbosity'
opts.on '--help' do
  puts opts
  exit
end

# Parse options
begin
  parser = Slop::Parser.new(opts)
  result = parser.parse(ARGV)
rescue Slop::UnknownOption => e
  puts "The Option '#{e.flag}' is unkown. Use '--help' for more information.".red
  exit
rescue Slop::MissingArgument => e
  puts "There was no Argument specified for the option '#{e.flags.join(', ')}'. Use '--help' for more information.".red
  exit
end

puts result[:H] #=> { hostname: "192.168.0.1", port: 80,
                 #     files: [], verbose: false }

puts opts # prints out help


puts "start babun"
pid = Process.spawn("#{config["cygwin_installation_path"]} -")
puts "Babun started with pid #{pid}"
Process.detach(pid)
