require File.join(File.dirname(__FILE__), "spec_helper")

describe Videojuicer::OAuth::RequestProxy do
  
  before(:each) { configure_test_settings }
  
  describe "instantiation" do
    before(:all) do
      Videojuicer.configure!(:foo=>"custom", :bar=>"not overridden")
    end
    
    it "gets the configuration defaults from those already set on the Videojuicer module" do
      prox = Videojuicer::OAuth::RequestProxy.new
      prox.config[:foo].should == "custom"
    end
    
    it "can override defaults from the Videojuicer configuration hash" do
      prox = Videojuicer::OAuth::RequestProxy.new(:bar=>"overridden")
      prox.config[:bar].should == "overridden"
    end
    
    %w(host port consumer_key consumer_secret token token_secret api_version).each do |attr|
      it "provides a direct access method for the #{attr} given in the configuration" do
        prox = Videojuicer::OAuth::RequestProxy.new((attr.to_sym)=>"#{attr} was set")
        prox.send(attr).should == "#{attr} was set"
      end
    end
  end
  
  describe "URL normalizer" do
    before(:all) do
      @proxy = Videojuicer::OAuth::RequestProxy.new
    end
    
    it "can sort a basic parameter hash correctly" do
      @proxy.normalize_params(:a=>"1", :b=>"2", :c=>"2", :d=>1).should == "a=1&b=2&c=2&d=1"
    end
    it "can sort complex nested parameter hashes correctly" do
      @proxy.normalize_params(:a=>"1", :b=>"2", :c=>{:a=>"AAA", :b=>"BBB", :c=>"CCC"}, :d=>{:e=>"foo"}).should == "a=1&b=2&c[a]=AAA&c[b]=BBB&c[c]=CCC&d[e]=foo"
    end
    
    it "does not include binary file parameters in the signature"
    
    it "escapes the signature base string elements and adjoins them with an ampersand" do
      @proxy.signature_base_string(:get, "/test", :foo=>"bar", :bar=>"baz").should == "GET&#{CGI.escape "http://localhost/test"}&#{CGI.escape "bar=baz&foo=bar"}"
    end
        
    describe "with no token supplied" do
      before(:all) do
        @proxy = Videojuicer::OAuth::RequestProxy.new(:token=>nil, :token_secret=>nil, :consumer_key=>"conkey", :consumer_secret=>"consec")
      end
      
      it "omits the token secret from the signature secret" do
        @proxy.signature_secret.should == "consec&"
      end
      
      it "omits the token from the signature params" do
        ap = @proxy.authify_params(:get, "/test", :a=>1, :b=>2)
        ap[:a].should == 1
        ap[:b].should == 2
        ap.include?(:oauth_token).should be_false
        ap[:oauth_consumer_key].should == "conkey"
      end
    end
    
    describe "with a token supplied" do
      before(:all) do
        @proxy = Videojuicer::OAuth::RequestProxy.new(:token=>"token", :token_secret=>"tosec", :consumer_key=>"conkey", :consumer_secret=>"consec")
      end
      
      it "includes the token secret in the signature secret" do
        @proxy.signature_secret.should == "consec&tosec"
      end
      
      it "includes the token automatically in the signature params" do
        ap = @proxy.authify_params(:get, "/test", :a=>1, :b=>2)
        ap[:a].should == 1
        ap[:b].should == 2
        ap[:oauth_token].should == "token"
        ap[:oauth_consumer_key].should == "conkey"
      end
    end
  end
      
  describe "request factory" do
    before(:all) do
      @seed = fixtures.seed
      @fixtures = fixtures["read-user"]
      @proxy = Videojuicer::OAuth::RequestProxy.new(:consumer_key=>@fixtures.consumer.consumer_key, :consumer_secret=>@fixtures.consumer.consumer_secret, :token=>nil, :token_secret=>nil)
    end
    
    it "can successfully retrieve a request token (indicating a successful signature verification)" do
      @proxy.consumer_key.should == @fixtures.consumer.consumer_key
      response = @proxy.get("/oauth/tokens", :seed_name=>@seed.name)
      response.body.should =~ /oauth_token=[a-zA-Z0-9]+&oauth_token_secret=[a-zA-Z0-9]+/
    end
  end
  
end