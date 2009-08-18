require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::Presentation do
  
  before(:all) do
    @klass = Videojuicer::Presentation
    configure_test_settings
  end

  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "presentation"
      @plural_name = "presentations"
    end
    
    it_should_behave_like "a RESTFUL resource model"
    it_should_behave_like "an embeddable"
  end
  
  
end