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
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
end