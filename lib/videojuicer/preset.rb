module Videojuicer
  class Preset
    include Videojuicer::Resource
    
    property :name,              String
    property :derived_type,      String
    property :created_at,        DateTime
    property :updated_at,        DateTime

    property :file_format,       String

    property :audio_bit_rate,    Integer  # bits per second
    property :audio_channels,    Integer
    property :audio_format,      String
    property :audio_sample_rate, Integer  # hertz

    property :video_bit_rate,    Integer  # bits per second
    property :video_format,      String
    property :video_frame_rate,  Float    # frames per second

    property :width,             Integer  # pixels
    property :height,            Integer  # pixels
    
    def self.formats
      response = instance_proxy.get(resource_route(:formats))
      JSON.parse(response.body)
    end
  end
end