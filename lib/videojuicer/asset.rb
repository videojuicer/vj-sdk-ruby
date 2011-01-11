module Videojuicer
  module Asset
    def self.all(options = {})
      proxy = Videojuicer::OAuth::RequestProxy.new(Videojuicer.current_scope)
      
      if options[:page]
        options[:offset] = Videojuicer::Resource::Collection.limit_from_page_number options.delete(:page), options[:limit]
      end
      
      response = proxy.get("/assets", "asset" => options)
      items, count, offset, limit = JSON.parse(response.body).values_at("items", "count", "offset", "limit")
      assets = items.map { |i| const_get(i.delete("type").capitalize).new(i) }
      
      # TODO: this should really be taken care of in VJ:Resource::initialize
      #       then VJ::Resource::CMs.all can also omit this step
      assets.each { |a| a.clean_dirty_attributes! }
      
      Videojuicer::Resource::Collection.new(assets, count, offset, limit)
    end
    
    TYPES = %w(Audio Document Image Flash Text Video)
    def self.types
      TYPES.map { |t| const_get(t) }
    end
  end
end
