module PTCP
  class Connections
    class Base
      class << self
        def start
          raise NoMethodError.new("#{self.class.name} needs to implement 'start()'")
        end
      end
    end
  end
end
