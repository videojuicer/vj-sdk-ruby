module Videojuicer
  class Movie
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
    property :slug,               String
    property :title,              String
    property :author,             String
    property :author_url,         String
    property :abstract,           String
    property :user_id,            Integer,  :writer=>:private
    property :callback_url,       String

    property :state,              String,   :default=>"ready" # see the STATES constant for values
    property :disclosure,         String,   :default=>"public" # see DISCLOSURES constant for values
    property :publish_from,       DateTime
    property :publish_until,      DateTime

    property :document_layout,    String
    property :document_content,   String # the presentation document
    property :document_type,      String, :default=>"SMIL 3.0"

    property :created_at,         DateTime
    property :updated_at,         DateTime

    property :image_asset_id,     Integer # FIXME make me a relationship helper

    property :tag_list,           String
   
  end 
end