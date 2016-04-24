require 'ptcp'

module PTCP
  class Connections
    class Ssh < PTCP::Connections::Base
      include PTCP
      class << self
        def start
          if Settings.user and Settings.host
            puts "start ssh session with #{Settings.cygwin_installation_path} #{Settings.ssh_client} #{Settings.user}@#{Settings.host}" if Settings.v
            pid = Process.spawn("#{Settings.cygwin_installation_path} #{Settings.ssh_client} #{Settings.user}@#{Settings.host}")
            puts "Babun started with pid #{pid}" if Settings.v
          else
            puts "start ssh session with #{Settings.cygwin_installation_path} #{Settings.ssh_client} #{Settings.host}" if Settings.v
            pid = Process.spawn("#{Settings.cygwin_installation_path} #{Settings.ssh_client} #{Settings.host}")
            puts "Babun started with pid #{pid}" if Settings.v
          end
          pid
        end
      end
    end
  end
end
