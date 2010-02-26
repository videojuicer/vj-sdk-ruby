$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

# Gem and stdlib dependencies
require 'rubygems'
require 'cgi'
require 'json'
require 'hmac-sha1'
require 'net/http'

# Core ext
require 'core_ext/hash'
require 'core_ext/string'
require 'core_ext/object'
require 'core_ext/cgi'
# Core mixins
require 'videojuicer/shared/exceptions'
require 'videojuicer/shared/configurable'
# Authentication and authorisation
require 'videojuicer/oauth/request_proxy'
require 'videojuicer/oauth/proxy_factory'
# Resource handling
require 'videojuicer/resource/embeddable'
require 'videojuicer/resource/types'
require 'videojuicer/resource/relationships/belongs_to'
require 'videojuicer/resource/errors'
require 'videojuicer/resource/collection'
require 'videojuicer/resource/inferrable'
require 'videojuicer/resource/property_registry'
require 'videojuicer/resource/base'
require 'videojuicer/session'
# Frontend models
require 'videojuicer/seed'
require 'videojuicer/user'
require 'videojuicer/campaign'
require 'videojuicer/campaign_policy'
require 'videojuicer/presentation'
require 'videojuicer/asset/audio'
require 'videojuicer/asset/document'
require 'videojuicer/asset/flash'
require 'videojuicer/asset/image'
require 'videojuicer/asset/text'
require 'videojuicer/asset/video'
require 'videojuicer/promo/base'
require 'videojuicer/criterion/date_range'
require 'videojuicer/criterion/geolocation'
require 'videojuicer/criterion/request'
require 'videojuicer/criterion/time'
require 'videojuicer/criterion/week_day'
require 'videojuicer/promo/base'
require 'videojuicer/preset'

module Videojuicer
  
  DEFAULTS = {
    :consumer_key     => nil,
    :consumer_secret  => nil,
    :token            => nil,
    :token_secret     => nil,
    :api_version      => nil,
    :seed_name        => nil,
    :user_id          => nil,
    :protocol         => "http",
    :host             => "api.videojuicer.com",
    :port             => 80
  }.freeze

  @default_options = {}
  @scope_stack = []
  
  class << self

    def scopes
      ([default_options]+@scope_stack).compact
    end
    
    def in_scope?
      !@scope_stack.empty?
    end
    
    def current_scope
      scopes.last
    end
    
    def enter_scope(config)
      @scope_stack.push current_scope.merge(config)
    end
    
    def exit_scope
      @scope_stack.pop
    end
    
    def exit_all!
      @scope_stack = []
    end
    
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
  end # class << self
end # module Videojuicer