require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::Campaign do
  
  before(:all) do
    @klass = Videojuicer::Campaign
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      string_mash = (("A".."z").to_a + ("a".."z").to_a)
      @singular_name = "campaign"
      @plural_name = "campaigns"
    end
    
    it_should_behave_like "a RESTFUL resource model"
    it_should_behave_like "a taggable"
  end
  
end