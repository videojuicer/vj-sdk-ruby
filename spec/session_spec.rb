require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::Session do
  
  before(:all) do 
    configure_test_settings
    @session = Videojuicer::Session.new(
      :seed_name        => fixtures.seed.name,
      :consumer_key     => fixtures["read-user"].consumer.consumer_key,
      :consumer_secret  => fixtures["read-user"].consumer.consumer_secret
    )
  end
  
  describe "instantiation" do
    before(:all) do
      @candidate_klass = Videojuicer::Session
    end    
    it_should_behave_like "a configurable"
  end
  
  describe "authorisation" do
    describe "(retrieving the request token)" do
      before(:all) do        
        @token = @session.get_request_token
      end
      
      it "fetches a token key" do
        @token.oauth_token.should be_kind_of(String)
        @token.oauth_token.should_not be_empty
      end
      it "fetches a token secret" do
        @token.oauth_token_secret.should be_kind_of(String)
        @token.oauth_token_secret.should_not be_empty
      end
      it "fetches the permissions" do
        @token.permissions.should == "read-user"
      end
    end
    
    describe "(authorizing the request token)" do
      before(:all) do
        @authorize_url = @session.authorize_url
        @authorize_url_parsed = URI.parse(@authorize_url)
      end
      
      it "returns the URL when asked for the #authorize_url" do
        @authorize_url_parsed.port.should == @session.port
        @authorize_url_parsed.host.should == @session.host
      end
      it "returns a valid URL that can be successfully requested" do
        req = Net::HTTP::Get.new("#{@authorize_url_parsed.path}?#{@authorize_url_parsed.query}")
        response =  Net::HTTP.start(@authorize_url_parsed.host, @authorize_url_parsed.port) do |http|
          http.request req
        end
        response.code.to_i.should == 200
      end
      it "validates that mangling this URL in any way also mangles the response to an error state" do
        req = Net::HTTP::Get.new("#{@authorize_url_parsed.path}?#{@authorize_url_parsed.query.gsub(/oauth_token=[a-zA-Z0-9]+/,'')}")
        response =  Net::HTTP.start(@authorize_url_parsed.host, @authorize_url_parsed.port) do |http|
          http.request req
        end
        response.code.to_i.should == 401
      end
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
  
  describe "concurrency" do
    
  end
  
  describe "scope control" do
    
  end
  
end