require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::User do
  
  before(:all) do
    @klass = Videojuicer::User
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "user"
      @plural_name = "users"
      @good_attributes = {
        :login => "testuser#{rand 99999}",
        :name => "#{rand 9999} Jones",
        :email => "test#{rand 999999}@test.videojuicer.com",
        :password => "#{p = rand(99999)}",
        :password_confirmation => p
      }
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
  describe "authentication" do
    before(:all) do
      @good_attributes = {
        :login => "testuser#{rand 99999}",
        :name => "#{rand 9999} Jones",
        :email => "test#{rand 999999}@test.videojuicer.com",
        :password => "#{p = rand(99999)}",
        :password_confirmation => p
      }
      @auth_user = Videojuicer::User.new(@good_attributes)
      @auth_user.save.should be_true
    end
    
    
    it "returns User with good credentials" do
      u = Videojuicer::User.authenticate(@good_attributes[:login], @good_attributes[:password])
      u.should be_kind_of(Videojuicer::User)
      u.login.should == @good_attributes[:login]
    end
    
    it "returns nil with bad credentials" do
      Videojuicer::User.authenticate(@good_attributes[:login], "FOOOOBARRRRRR").should be_nil
    end
  end
  
end