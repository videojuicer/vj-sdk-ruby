module Videojuicer
  class Campaign
    class CampaignPolicy
      include Videojuicer::Resource
    
      # Resource should note that this is a class within a class
      # Should treat parent class as parent resource
      
      property :presentation_id,  Integer
      property :campaign_id,      Integer
      property :created_at,       DateTime
      property :updated_at,       DateTime
      
      belongs_to :campaign
      
  
    end
  end
end