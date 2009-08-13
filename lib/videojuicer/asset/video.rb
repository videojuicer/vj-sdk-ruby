require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Asset
    class Video < Base
      property :bit_rate,          Integer # bits per second
      
      property :audio_bit_rate,    Integer # bits per second
      property :audio_format,      String
      property :audio_sample_rate, Integer # hertz
      property :audio_stereo,      String

      property :video_bit_rate,    Integer # bits per second
      property :video_format,      String
      property :video_frame_rate,  Float   # frames per second

      property :width,             Integer # pixels
      property :height,            Integer # pixels
    end
  end
end