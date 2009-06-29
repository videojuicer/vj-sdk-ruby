require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Asset
    class Audio < Base
      
      property :bit_rate, Integer
      
    end
  end
end