=begin rdoc
  
  A module that provides OEmbed functionality to any Videojuicer::Resource model.

=end

module Videojuicer
  module Resource
    module Embeddable
      
      OEMBED_ENDPOINT = "/oembed".freeze
      
      def oembed_payload(maxwidth, maxheight)
        proxy = proxy_for(config)
        result = proxy.get(OEMBED_ENDPOINT, :format=>"json", :url=>"#{proxy.host_stub}#{resource_path}?seed_name=#{seed_name}", :maxwidth=>maxwidth, :maxheight=>maxheight)
        JSON.parse(result.body)
      end
      
      def embed_code(maxwidth, maxheight)
        oembed_payload(maxwidth, maxheight)["html"]
      end
      
    end
  end
end