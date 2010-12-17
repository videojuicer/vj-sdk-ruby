module Videojuicer
  module Asset
    class All
    
      include Videojuicer::Resource
      include Videojuicer::Exceptions
    
      property :name,          String
      property :friendly_name, String
      property :type,          String
      property :http_url,      String
      property :created_at,    DateTime
      property :updated_at,    DateTime
      
      def self.singular_name
        "asset"
      end
    
      def self.base_path(options={})
        "/assets"
      end
    
      def derive(preset)
        response = proxy_for(config).post(resource_path, :preset_id => preset.id)
        self.class.new(JSON.parse(response.body))
      end
    
      def returnable_attributes
        attrs = super
        attrs.delete(:file) unless new_record?
        attrs
      end
    
      def set_derived(from_asset, preset)
        params = {
          :original_asset_type => from_asset.class.to_s.split("::").last,
          :original_asset_id => from_asset.id,
          :preset_id => preset.id
        }
        response = proxy_for(config).post(resource_path(:set_derived), params)
        self.attributes = JSON.parse(response.body)
      end
    end 
  end
end