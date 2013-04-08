require "helpers/spec_helper"

describe Videojuicer::OAuth::RequestProxy do
  
  before(:each) do
    configure_test_settings
  end
  
  describe "instantiation" do
    before(:all) do
      @klass = Videojuicer::OAuth::RequestProxy
    end    
    it_should_behave_like "a configurable"
  end
  
  describe "URL normalizer" do
    before(:all) do
      @proxy = Videojuicer::OAuth::RequestProxy.new
    end
    
    it "can split a parameter hash into a regular and multipart hash" do
      f = File.open(__FILE__)
      params = {:user=>{:attributes=>{:file=>f, :name=>"user name"}}, :foo=>"bar"}
      normal, multipart = @proxy.split_by_signature_eligibility(params)
      normal.should == {:user=>{:attributes=>{:name=>"user name"}}, :foo=>"bar"}
      multipart.should == {:user=>{:attributes=>{:file=>f}}}
    end
    
    it "can sort a basic parameter hash correctly" do
      @proxy.normalize_params(:a=>"1", :b=>"2", :c=>"2", :d=>1).should == "a=1&b=2&c=2&d=1"
    end
    it "can sort complex nested parameter hashes correctly" do
      @proxy.normalize_params(:a=>"1", :b=>"2", :c=>{:a=>"AAA", :b=>"BBB", :c=>"CCC"}, :d=>{:e=>"foo"}).should == "a=1&b=2&c%5Ba%5D=AAA&c%5Bb%5D=BBB&c%5Bc%5D=CCC&d%5Be%5D=foo"
    end    
    it "escapes the signature base string elements and adjoins them with an ampersand" do
      @proxy.signature_base_string(:get, "/test", :foo=>"bar", :bar=>"baz").should == "GET&#{CGI.rfc3986_escape "http://localhost:6666/test"}&#{CGI.rfc3986_escape "bar=baz&foo=bar"}"
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
      @fix = fixtures["write-master"]
      @proxy = Videojuicer::OAuth::RequestProxy.new(:seed_name=>@seed.name, :consumer_key=>@fix.consumer.consumer_key, :consumer_secret=>@fix.consumer.consumer_secret, :token=>nil, :token_secret=>nil)
    end
    
    it "can successfully retrieve a request token (indicating a successful signature verification)" do
      @proxy.consumer_key.should == @fix.consumer.consumer_key
      response = @proxy.get("/oauth/tokens")
      response.body.should =~ /oauth_token=[a-zA-Z0-9]+&oauth_token_secret=[a-zA-Z0-9]+/
    end
  end
  
end
