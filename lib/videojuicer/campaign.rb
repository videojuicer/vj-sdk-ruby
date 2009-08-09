module Videojuicer
  class Campaign
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
    property :name,     String
    property :user_id,  Integer
      belongs_to :user, :class=>Videojuicer::User
    
    attr_accessor :campaign_policies
    def campaign_policies=(arg)
      # Loop over and make objects or something
      @campaign_policies=(arg)
    end
    
  end
end
