module Videojuicer
  module Resource
    class Errors < Hash
      
      def initialize(error_hash)
        self.merge!(error_hash)
      end
      
      def on(key)
        o = self[key.to_s]    
        o = (o.is_a?(Array))? o.uniq : [o]
        return (o.compact.empty?)? nil : o.compact
      end
      
    end
  end
end