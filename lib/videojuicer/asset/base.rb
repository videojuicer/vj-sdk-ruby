module Videojuicer
  module Asset
    class Base
      
      def self.inherited(base)
        base.send(:include, Videojuicer::Resource)
        base.send(:extend, Videojuicer::Asset::Base::ClassMethods)
        base.send(:include, Videojuicer::Asset::Base::InstanceMethods)
        
        # - heritage
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
        def returnable_attributes
          attrs = super
          attrs.delete(:file) unless new_record?
          attrs
        end
      end
      
    end
  end
end