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
    
    
  end
  
end