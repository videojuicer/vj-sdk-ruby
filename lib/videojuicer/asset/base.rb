module Videojuicer
  module Asset
    class Base
      
      def self.inherited(base)
        base.send(:include, Videojuicer::Resource)
        base.send(:extend, Videojuicer::Asset::Base::ClassMethods)
        base.send(:include, Videojuicer::Asset::Base::InstanceMethods)
        
        base.property :user_id,          Integer
        # - generic file handling
        base.property :file,             File
        base.property :file_name,        String, :writer=>:private
        base.property :file_size,        Integer, :writer=>:private
        # - common metadata
        base.property :duration,         Integer # milliseconds
        base.property :licensed_at,      Date
        base.property :licensed_by,      String
        base.property :licensed_under,   String
        base.property :published_at,     Date
        # - access control / workflow
        base.property :disclosure,       String
        base.property :state,            String, :writer => :private
      end
      
      module ClassMethods
        def singular_name
          "asset"
        end
        
        def base_path
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