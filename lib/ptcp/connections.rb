require 'ptcp/connections/base'

module PTCP
  class Connections
    class << self

    def [](connection)
      connections[connection.to_s.downcase]
    end

    def all
      Dir[path '*'].collect do |connection|
        File.basename(connection, '.rb').downcase
      end
    end

    def available?(connection)
      all.include?(connection.to_s.downcase)
    end

    private

    def connections
      @@connections ||= Hash.new do |hash, connection|
        connection = connection.to_s.downcase
        if File.exist?(path connection)
          require "ptcp/connections/#{connection}"
          class_name = "PTCP::Connections::#{connection.capitalize}"
          hash[connection] = (eval class_name)
        else
          raise "connection #{connection} is not supported!"
        end
      end
    end

    def path(connection)
      File.expand_path(
        File.join(File.dirname(__FILE__), 'connections', "#{connection}.rb")
      )
    end
  end
end
end
