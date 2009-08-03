require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Asset
    class Audio < Base
      property :bit_rate,    Integer # bits per second
      property :format,      String
      property :sample_rate, Integer # hertz
      property :stereo,      String
    end
  end
end