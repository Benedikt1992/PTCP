require 'ptcp/connections'
require 'ptcp/settings'
require 'colorize'

module PTCP
  class Connections
    class Ssh < PTCP::Connections::Base
      include PTCP
      class << self
        def start
          begin
            pid = Process.spawn(build_command)
          rescue TypeError => e
            puts "Couldn't spawn ssh process: #{e.message}".red
            exit
          end

          puts "Babun started ssh with pid #{pid}".green if Settings.v
          pid
        end

        private

        def build_command
          command = "#{Settings.cygwin_installation_path} #{Settings.ssh_client}"

          command << " #{user}@#{host}"

          puts "Start ssh session with #{command}".green if Settings.v

          command
        end

        def user
          unless Settings.user
            print "login as: "
            STDOUT.flush
          end
          Settings.user || STDIN.gets.chomp
        end

        def host
          Settings.host
        end
      end
    end
  end
end
