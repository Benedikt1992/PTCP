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

  # No argument, shows at tail.  This will print an options summary.
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

end.parse!


puts "start babun"
pid = Process.spawn("#{config["cygwin_installation_path"]} -")
puts "Babun started with pid #{pid}"
Process.detach(pid)
