#!/usr/bin/env ruby

begin
   require 'colorize'
   require 'pp'
   require 'optparse'
   require 'yaml'
rescue LoadError => e
   puts "Couldn't load required Gem: #{e.message.slice!(25..50)}!".red
   exit
end
raise IOError ,"Config file not found. Please place the file \"config.yaml\" into #{Dir.pwd}".red if not(File.exists?("config.yaml"))
config = YAML.load_file("config.yaml")

# Original Manual http://tartarus.org/~simon/putty-snapshots/htmldoc/Chapter3.html#using-cmdline

# Parse the parameters from commandline
options = {}
OptionParser.new do |opts|
  #TODO Copyright informations with link and auto completion
  opts.banner = "Usage: puttytocygwinproxy.rb [options]"

  opts.separator ""
  opts.on('-v', '--verbose', 'Increase verbosity') { |v| options[:verbose] = v }
  opts.on('-ssh', '--ssh-protocol', 'selects the SSH protocol') { |v| options[:ssh] = v }
  opts.on('-telnet', '--telnet-protocol', 'selects the Telnet protocol') { |v| options[:telnet] = v }
  opts.on('-rlogin', '--rlogin-protocol', 'selects the Rlogin protocol') { |v| options[:rlogin] = v }
  opts.on('-raw', '--raw-protocol', 'selects the raw protocol') { |v| options[:raw] = v }
  opts.on('-serial', '--serial-protocol', 'selects a serial connection') { |v| options[:serial] = v }

  # No argument, shows at tail.  This will print an options summary.
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

end.parse!

puts options[:ssh]


puts "start babun"
pid = Process.spawn("#{config["cygwin_installation_path"]} -")
puts "Babun started with pid #{pid}"
Process.detach(pid)
