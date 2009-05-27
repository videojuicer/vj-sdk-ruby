require File.join(File.dirname(__FILE__), "spec_helper")

describe Videojuicer::Session do
  
  before(:all) { configure_test_settings }
  
  describe "initialization" do    
    it "accepts an options hash"
    it "requires at least a seed name"
    
    describe "without a token or token secret" do
      it "returns false when sent #authorized?"
    end
    
    describe "with a token and token secret" do
      it "returns true when sent #authorized?"
    end
  end
  
  describe "authorisation" do
    describe "(before request token is received)" do      
      it "returns false when sent #authorized?"
      it "raises a NoRequestToken exception when asked for the #authorize_url"
    end
    
    describe "(retrieving the request token)" do
      it "fetches a token key"
      it "fetches a token secret"
    end
    
    describe "(authorizing the request token)" do
      it "returns the URL when asked for the #authorize_url"
      it "does not re-fetch the request token when asked for the #authorize_url multiple times"
    end
    
    describe "(retrieving the access token)" do
      it "fetches a token key"
      it "fetches a token secret"
      it "fetches the token permissions"
    end
    
    describe "(after access token is retrieved)" do
      it "returns true when sent #authorized?"
    end
  end
  
  describe "scope control" do
    
  end
  
  
#  #########################
#  ## Test Implementation ##
#  #########################
#
#  Videojuicer.configure!({
#    :consumer_key => "wdQjFa4CV0zVksG", 
#    :consumer_secret => "2abdTMZWWCa8aO1fcn46HdfPUxfU2Z0o6tO6U9y8",
#    :api_version => 1
#  })
#
#  token_key, token_secret = Videojuicer::Session.get_request_token(:seed_name => "splendidness")
#  #puts token_key
#  #puts token_secret
#  session = Videojuicer::Session.new(
#    :seed_name => "splendidness", :token_key => token_key, :token_secret => token_secret
#  )
#
#  puts session.authorize!
  
end