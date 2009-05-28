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
    
    # Makes a call to the Videojuicer OAuth provider, requesting an unauthorised Request Token
    # which will be returned as a Mash.
    #
    # See http://oauth.net/core/1.0/#auth_step1 for details.
    #
    # Each session will make only one request for an unauthorised request token. Further calls to
    # get_request_token will return the same token and token secret.
    #
    # The Mash responds to the following methods:
    # +oauth_token+ - The token key to be used as the oauth_token in calls using this token.
    # +oauth_token_secret+ - The token secret to be used when signing requests using this token.
    # +expires+ - The date and time at which the token will become invalid.
    # +permissions+ - The permissions that you wish the token to have. Will be one of read-user, write-user, read-master or write-master.
    def get_request_token
      # GET tokens.js
      @request_token_response ||= JSON.parse(proxy_for(config).get("/oauth/tokens.js").body)
      Mash.new(
        @request_token_response["request_token"]
      )
    end
    
    # Generates and returns a fully-qualified signed URL that the user should be directed to
    # by the consumer.
    #
    # See http://oauth.net/core/1.0/#auth_step2 for details.
    #
    # Can optionally be given a Mash previously obtained from a call to get_request_token, but in most
    # cases this is not necessary - a request token will be requested and used automatically if one 
    # is not supplied.
    def authorize_url(token=get_request_token)
      proxy_for(config.merge(:token=>token.oauth_token, :token_secret=>token.oauth_token_secret)).signed_url(:get, "/oauth/tokens/new")
    end
    
    # Once a user has completed the OAuth authorisation procedure at the provider end, you may call 
    # exchange_request_token to make a request to the provider that will exchange your unauthorised
    # request token for the corresponding authorised access token.
    #
    # See http://oauth.net/core/1.0/#auth_step3 for details.
    #
    # Returns a Mash that responds to the following methods:
    # +oauth_token+ - The token key to be used as the oauth_token in calls using this token.
    # +oauth_token_secret+ - The token secret to be used when signing requests using this token.
    # +expires+ - The date and time at which the token will become invalid.
    # +permissions+ - The permissions that you wish the token to have. Will be one of read-user, write-user, read-master or write-master.
    def exchange_request_token(token=get_request_token)
      proxy = proxy_for(config.merge(:token=>token.oauth_token, :token_secret=>token.oauth_token_secret))
      Mash.new JSON.parse(proxy.get("/oauth/tokens.js").body)["access_token"]
    end
    

    
    def authorize!
      # GET tokens.js with magic params
      puts "not yet authorized"
    end
    
  end
end