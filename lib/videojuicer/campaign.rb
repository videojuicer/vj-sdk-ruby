module Videojuicer
  class Campaign
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
    property :name,         String
    property :user_id,      Integer
    property :target_type,  String
    property :target_id,    Integer
    property :disclosure,   String
    property :created_at,   DateTime
    property :updated_at,   DateTime
    
    belongs_to :user, :class=>Videojuicer::User
    
    attr_accessor :criteria
    attr_accessor :targets
    attr_accessor :inserts
  end
end
