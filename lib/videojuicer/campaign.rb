module Videojuicer
  class Campaign
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
    property :name,             String
    property :user_id,          Integer
    property :insert_domain,    String
    property :presentation_id,  Integer
    property :disclosure,       String
    property :created_at,       DateTime
    property :updated_at,       DateTime
    
    belongs_to :user, :class=>Videojuicer::User
    
    attr_accessor :criteria
    attr_accessor :presentations
    attr_accessor :inserts
  end
end
