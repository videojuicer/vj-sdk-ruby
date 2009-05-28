module Videojuicer
  module Configurable
    
    attr_accessor :config
    
    def configure!(options={})
      self.config = Videojuicer.default_options.merge(config || {}).merge(options)
    end
    
    # Retrieves the host from the configuration options.
    def host; config[:host]; end
    # Retrieves the port from the configuration options.
    def port; config[:port]; end
    # Retrieves the consumer_key from the configuration options.
    def consumer_key; config[:consumer_key]; end
    # Retrieves the consumer_secret from the configuration options.
    def consumer_secret; config[:consumer_secret]; end
    # Retrieves the token from the configuration options.
    def token; config[:token]; end
    # Retrieves the token_secret from the configuration options.
    def token_secret; config[:token_secret]; end
    # Retrieves the api_version from the configuration options.
    def api_version; config[:api_version]; end
    # Retrieves the protocol from the configuration options.
    def protocol; config[:protocol]; end
    # Retrieves the seed name from the configuration options.
    def seed_name; config[:seed_name]; end
    
  end
end