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
    
    def self.create(user, attributes)
      seed = new(attributes)
      proxy = seed.proxy_for(seed.config)

      user.errors = { }

      seed_param_key = seed.class.parameter_name
      user_param_key = user.class.parameter_name

      response = proxy.put('/seeds/create.json',
                           seed_param_key=>seed.returnable_attributes,
                           user_param_key=>user.returnable_attributes)

      result = response.body.is_a?(Hash) ? response.body : JSON.parse(response.body) rescue raise(JSON::ParserError, "Could not parse #{response}: \n\n #{response.body}")

      if !result["seed"].nil?
        seed.validate_committed_response(result["seed"])
      end

      if !result["user"].nil?
        user.validate_committed_response(result["user"])
      end

      return [ result["token"].deep_symbolize, seed, user ]
    end
  end
end
