require File.join(File.dirname(__FILE__), "..", "helpers",  "spec_helper")

describe Videojuicer::Asset::Image do
  
  before(:all) do
    @klass = Videojuicer::Asset::Image
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "asset"
      @plural_name = "assets/image"
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
  
end