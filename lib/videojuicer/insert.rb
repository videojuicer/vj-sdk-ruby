module Videojuicer
  class Insert
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
    property :campaign_id,  Integer
    property :role,         String
    property :offset_time,  Integer
    property :offset_x,     Integer
    property :offset_y,     Integer
    property :anchor_x,     String
    property :anchor_y,     String
    property :click_href,   String
    property :click_target, String
    property :asset_type,   String
    property :asset_id,     Integer
    property :created_at,   DateTime
    property :updated_at,   DateTime
    
    belongs_to :campaign, :class=>Videojuicer::Campaign
  end
end