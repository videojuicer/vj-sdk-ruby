require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Asset
    class Video < Base
      property :bit_rate,          Integer, :writer => :private # bits per second
      property :duration,          Integer, :writer => :private # milliseconds

      property :audio_bit_rate,    Integer, :writer => :private # bits per second
      property :audio_channels,    Integer, :writer => :private
      property :audio_format,      String,  :writer => :private
      property :audio_sample_rate, Integer, :writer => :private # hertz

      property :video_bit_rate,    Integer, :writer => :private # bits per second
      property :video_format,      String,  :writer => :private
      property :video_frame_rate,  Float,   :writer => :private # frames per second

      property :width,             Integer, :writer => :private # pixels
      property :height,            Integer, :writer => :private # pixels
    end
  end
end