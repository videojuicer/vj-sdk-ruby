module Videojuicer
  class Presentation
    include Videojuicer::Resource
    include Videojuicer::Resource::Embeddable
    include Videojuicer::Exceptions
    
    property :title,              String
    property :author,             String
    property :author_url,         String
    property :abstract,           String
    property :user_id,            Integer,  :writer=>:private
      belongs_to :user, :class=>Videojuicer::User
    property :updater_id,         Integer
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
    property :image_asset_url,    String, :writer=>:private

    property :tag_list,           String
   
    attr_accessor :image_asset
    @@asset_types = %w(video flash image document audio)
    
    def permalink
      proxy = proxy_for(config)
      "#{proxy.host_stub}/presentations/#{id}.html?seed_name=#{seed_name}".gsub(":80/","/")
    end
    
    def asset_ids
      Videojuicer::SDKLiquidHelper::Filters::AssetBlock.reset!
      @@asset_types.each do |type|
        Liquid::Template.register_tag type, Videojuicer::SDKLiquidHelper::Filters::AssetBlock
      end
      @template = Liquid::Template.parse(document_content)
      @template.render
      return Videojuicer::SDKLiquidHelper::Filters::AssetBlock.asset_ids
    end
    
    #get the thumbnail image associated with the presentation
    def image_asset
      @image_asset ||= Videojuicer::Asset::Image.get(image_asset_id)
      return @image_asset unless block_given?
      yield @image_asset if block_given?
    end
    
    #video_asset_ids and video_assets methods
    @@asset_types.each do |type|
        sym_type = type.to_sym
        define_method "#{type}_asset_ids" do
            asset_ids[sym_type]
        end
        define_method "#{type}_assets" do
          @assets ||= {}
          @assets[sym_type] ||= Videojuicer::Asset.const_get(type.capitalize.to_sym).all :id => asset_ids[sym_type].join(',') rescue []
        end
    end
    
  end 
end