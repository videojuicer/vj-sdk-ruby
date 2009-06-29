require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Asset
    class Video < Base
      
      property :width,    Integer # pixels
      property :height,   Integer # pixels
      property :bit_rate, Integer # bits per second
      
    end
  end
end