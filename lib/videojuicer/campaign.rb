module Videojuicer
  class Campaign
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
    property :name,     String
    property :user_id,  Integer
      belongs_to :user
      
    
  end
end
