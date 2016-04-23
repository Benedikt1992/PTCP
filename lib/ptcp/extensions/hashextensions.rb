module PTCP
  module Extensions
    module HashExtensions
      def symbolize_keys!
        inject({}) do |acc, (k,v)|
          key = String === k ? k.to_sym : k
          value = Hash === v ? v.symbolize_keys! : v
          acc[key] = value
          acc
        end
      end
    end
  end
end
Hash.send(:include, PTCP::Extensions::HashExtensions)
