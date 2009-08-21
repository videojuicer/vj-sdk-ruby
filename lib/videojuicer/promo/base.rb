module Videojuicer
  module Promo
    def self.model_map
      { :audio  => Videojuicer::Promo::Audio,
        :images => Videojuicer::Promo::Image,
        :texts  => Videojuicer::Promo::Text,
        :videos => Videojuicer::Promo::Video
      }
    end
    
    class Base
      
      def self.inherited(base)
        base.send(:include, Videojuicer::Resource)
        base.send(:extend, Videojuicer::Promo::Base::ClassMethods)
        base.send(:include, Videojuicer::Promo::Base::InstanceMethods)
        
        base.property :campaign_policy_id,  Integer
        base.property :asset_id,            Integer
        base.property :role,                String
        base.property :href,                String
      end
      
      module ClassMethods
        def singular_name
          "promo"
        end
        
        def base_path(options={})
          "/promos/#{self.to_s.split("::").last.snake_case}"
        end
        
        def get(*args); raise NoMethodError; end
        def all(*args); raise NoMethodError; end
        def first(*args); raise NoMethodError; end
      end
      
      module InstanceMethods
        def save(*args); raise NoMethodError; end
        def destroy(*args); raise NoMethodError; end
        def asset
          Videojuicer::Asset.const_get(self.class.to_s.split("::").last).get(asset_id)
        end
        def matcher_keys
          [:campaign_policy_id, :asset_id, :role, :href]
        end
        def matcher_attributes
          matcher_keys.inject({}) do |memo, attr|
            memo.update(attr => self.send(attr))
          end
        end
      end
            
    end
    
    class Audio < Base
    end

    class Image < Base
    end

    class Text < Base
    end
    
    class Video < Base
    end
    
    class Heart < Base
    end
    
  end
end