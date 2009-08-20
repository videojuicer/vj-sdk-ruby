require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Asset
    class Audio < Base
      property :bit_rate,    Integer, :writer => :private # bits per second
      property :channels,    Integer, :writer => :private
      property :duration,    Integer, :writer => :private # milliseconds
      property :format,      String,  :writer => :private
      property :sample_rate, Integer, :writer => :private # hertz
    end
  end
end