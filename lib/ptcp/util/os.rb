require 'rbconfig'

module PTCP
  module Util
    module OS
      def self.is_windows?
        begin
          env_os = ENV['OS']
        rescue NameError
          return false
        end
        if RbConfig::CONFIG['host_os'] =~ /^mingw2$|^mingw$|^mswin$|^windows$/
            true
        elsif env_os  == 'Windows_NT'
            true
        else
            false
        end
      end
    end
  end
end
