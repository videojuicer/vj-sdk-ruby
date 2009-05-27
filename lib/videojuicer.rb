$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

require 'rubygems'
require 'hmac/sha1'
require 'cgi'
require 'net/http'

require 'videojuicer/oauth/request_proxy'
require 'videojuicer/session'
require 'videojuicer/exceptions'

module Videojuicer
  
  DEFAULTS = {
    :consumer_key     => nil,
    :consumer_secret  => nil,
    :api_version      => nil,
    :host             => "http://api.videojuicer.com",
    :port             => 80
  }.freeze
  
  @default_options = {}
  
  def self.configure!(options={})
    @default_options = DEFAULTS.merge(@default_options.merge(options))
  end
  
  def self.unconfigure!
    @default_options = DEFAULTS
  end
  
  def self.default_options
    @default_options
  end
  
end