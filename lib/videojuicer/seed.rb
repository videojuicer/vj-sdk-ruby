module Videojuicer
  class Seed
    include Videojuicer::Resource
    include Videojuicer::Exceptions
   
    property :name, String
    property :provider_name, String
    property :provider_url, String
    property :google_analytics_id, String
   
    # Returns the currently-configured seed
    def self.current
      proxy = Videojuicer::OAuth::RequestProxy.new
      jobj = JSON.parse(proxy.get("/seeds/current.json").body)
      new(jobj)
    end
    
  end
end