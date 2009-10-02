module Videojuicer
  class Campaign
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
    property :name,     String
    property :user_id,  Integer
    property :created_at, DateTime
    property :updated_at, DateTime
    belongs_to :user, :class=>Videojuicer::User
    
    attr_accessor :campaign_policies
    def campaign_policies=(arg)
      # Loop over and make objects or something
      @campaign_policies=(arg)
    end
    
  end
end
