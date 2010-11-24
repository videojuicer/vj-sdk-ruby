module Videojuicer
  class Assets
    
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
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
    
    def file
      raise "use the value of #{self.class}#url to download a copy of the asset"
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