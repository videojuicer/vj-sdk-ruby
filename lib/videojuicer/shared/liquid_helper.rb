module Videojuicer
  module SDKLiquidHelper
    module Filters
      
      class AssetBlock < ::Liquid::Block
        
        @@asset_ids = {}
        
        def self.reset!
          @@asset_ids = {}
        end
        
        def self.asset_ids
          @@asset_ids.deep_symbolize
        end
        
        def initialize tag_name, args, tokens
          @@asset_ids[tag_name] ||= []
          @@asset_ids[tag_name] << tokens.to_s.gsub(/\{% id ([0-9]+){1,10} %\}.*/, "\\1").strip
          super
        end
        
        def render; nil; end;
        
        def unknown_tag tag_name, args, tokens; nil; end;
        
      end#end class
      
      class SmilVideoFragment < ::Liquid::Block
        
      end
      
      class IdFragment < ::Liquid::Tag
      end
      
      class DeliveryFragment < ::Liquid::Tag
      end
      
    end
  end
end