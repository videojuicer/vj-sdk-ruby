$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

require 'rubygems'
require 'hmac/sha1'
require 'cgi'
require 'net/http'
require 'json'


require 'videojuicer/shared/exceptions'
require 'videojuicer/shared/configurable'

require 'videojuicer/oauth/request_proxy'
require 'videojuicer/oauth/proxy_factory'

require 'videojuicer/session'

module Videojuicer
  
  DEFAULTS = {
    :consumer_key     => nil,
    :consumer_secret  => nil,
    :token            => nil,
    :token_secret     => nil,
    :api_version      => nil,
    :seed_name        => nil,
    :protocol         => "http",
    :host             => "api.videojuicer.com",
    :port             => 80
  }.freeze

  @default_options = {}  
  
  class << self

    
    def [](key)
      @default_options[key]
    end
    
    def configure!(options={})
      @default_options = DEFAULTS.merge(@default_options.merge(options))
    end

    def unconfigure!
      @default_options = DEFAULTS
    end

    def default_options
      @default_options
    end
  end
  
  
end