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

puts "start babun"
pid = Process.spawn("#{config["cygwin_installation_path"]} -")
puts "Babun started with pid #{pid}"
Process.detach(pid)
