module Videojuicer
  module Asset
    class Base
      
      def self.inherited(base)
        base.send(:include, Videojuicer::Resource)
        base.send(:extend, Videojuicer::Asset::Base::ClassMethods)
        base.send(:include, Videojuicer::Asset::Base::InstanceMethods)
        
        # - heritage
        base.property :derived_internally,  Videojuicer::Resource::Types::Boolean, :writer => :private
        base.property :original_asset_id,   Integer,  :writer => :private
        base.property :original_asset_type, String,   :writer => :private
        base.property :preset_id,           Integer,  :writer => :private
        base.property :user_id,             Integer,  :writer => :private
        
        # - transformation
        base.property :source_space_window, String,   :writer => :private
        base.property :source_time_window,  String,   :writer => :private
        
        # - generic file handling
        base.property :file,                File
        base.property :file_name,           String
        base.property :file_size,           Integer,  :writer => :private # bytes
        
        # - common metadata
        base.property :licensed_at,         Date
        base.property :licensed_by,         String
        base.property :licensed_under,      String
        base.property :published_at,        Date
        
        # - access control / workflow
        base.property :url,                 String,   :writer => :private
        base.property :http_url,            String,   :writer => :private
        base.property :state,               String,   :writer => :private
        base.property :state_changed_at,    DateTime, :writer => :private
        base.property :state_changed_url,   String
        base.property :created_at,          DateTime
        base.property :updated_at,          DateTime
      end
      
      module ClassMethods
        def singular_name
          "asset"
        end
        
        def base_path(options={})
          "/assets/#{self.to_s.downcase.split("::").last}"
        end
      end
      
      module InstanceMethods
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
  end
end