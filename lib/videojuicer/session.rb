module Videojuicer
  class Session
    def self.get_request_token(seed_name)
      # GET tokens.js
      ["token_key_#{rand(2**32)}", "token_secret_#{rand(2**32)}"]
    end
    
    def initialize(h={})
      return ArgumentError, "Options is not a hash" unless h.is_a?(Hash)
      @default_options = h
    end
    
    def authorize!
      # GET tokens.js with magic params
      puts "not yet authorized"
    end
  end
end