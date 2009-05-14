require 'rubygems'
require 'hmac'
require 'videojuicer/session'

module Videojuicer
  
  @default_options = {
    :consumer_key => nil,
    :consumer_secret => nil,
    :api_version => nil
  }
  
  def self.configure!(options={})
    @default_options = options
  end
  
  def self.default_options
    @default_options
  end
end

#########################
## Test Implementation ##
#########################

Videojuicer.configure!({
  :consumer_key => "wdQjFa4CV0zVksG", 
  :consumer_secret => "2abdTMZWWCa8aO1fcn46HdfPUxfU2Z0o6tO6U9y8",
  :api_version => 1
})

token_key, token_secret = Videojuicer::Session.get_request_token(:seed_name => "splendidness")
#puts token_key
#puts token_secret
session = Videojuicer::Session.new(
  :seed_name => "splendidness", :token_key => token_key, :token_secret => token_secret
)

session.authorize!