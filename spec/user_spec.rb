require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::User do
  
  before(:all) do
    @klass = Videojuicer::User
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "user"
      @plural_name = "users"
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
  describe "authentication" do
    before(:all) do
      @attrs = Videojuicer::User.gen_attributes
      @auth_user = Videojuicer::User.new(@attrs)
      @auth_user.save.should be_true
    end
    
    
    it "returns User with good credentials" do
      u = Videojuicer::User.authenticate(@attrs[:login], @attrs[:password])
      u.should be_kind_of(Videojuicer::User)
      u.login.should == @attrs[:login]
    end
    
    it "returns nil with bad credentials" do
      Videojuicer::User.authenticate(@attrs[:login], "FOOOOBARRRRRR").should be_nil
    end
  end
  
end