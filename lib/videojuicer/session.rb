=begin rdoc

  A Videojuicer::Session object is the primary means of giving scope to your API calls.

=end

module Videojuicer
  class Session
        
    include Videojuicer::Configurable
    include Videojuicer::OAuth::ProxyFactory
    
    def initialize(options={})
      configure!(options)
    end
    
    def get_request_token
      # GET tokens.js
      @request_token_response ||= JSON.parse(proxy_for(config).get("/oauth/tokens.js").body)
      Mash.new(
        @request_token_response["request_token"]
      )
    end
    
    def authorize_url(token=get_request_token)
      proxy_for(config.merge(:token=>token.oauth_token, :token_secret=>token.oauth_token_secret)).signed_url(:get, "/oauth/tokens/new")
    end
    

    
    def authorize!
      # GET tokens.js with magic params
      puts "not yet authorized"
    end
    
  end
end