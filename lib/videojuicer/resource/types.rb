module Videojuicer
  module Resource
    module Types
      
      class Base
        def self.load(value)
          return self.new(value)
        end

        def initialize(value)
          @raw = value
        end
        
        # Returns the source value
        attr_reader :raw
      end
      
      class Boolean < Base
        # Boolean.new("1").dump #=> true
        # Returns the coerced value
        def dump
          [1, "1", "true", "yes"].include?(raw)
        end        
      end
    
    end
  end
end