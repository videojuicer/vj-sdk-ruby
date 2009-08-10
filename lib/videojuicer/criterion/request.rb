require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class Request < Base
      
      property :referrer,           String, :nullable => false
      property :exclude,            Boolean
      
      def matcher_keys
        [:referrer, :exclude]
      end
    end
  end
end