require 'ptcp/connections'
require 'ptcp/settings'
require 'colorize'
require 'win32ole'

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

          enter_password(into_pid: pid) if Settings.pw

          pid
        end

        private

        def build_command
          command = "#{Settings.cygwin_installation_path} -t '#{title}' -e #{Settings.ssh_client}"

          command << " #{user}@#{host}"

          puts "Start ssh session with #{command}".green if Settings.v

          command
        end

        def enter_password(opts={})
          process = opts[:into_pid] || title
          wsh = WIN32OLE.new('WScript.Shell')
          while not  wsh.AppActivate(process)
            sleep 0.1
          end
          sleep 0.5
          wsh.SendKeys(Settings.pw)
          wsh.SendKeys('{ENTER}')
        end

        def title
          "ssh #{user}@#{host}"
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
