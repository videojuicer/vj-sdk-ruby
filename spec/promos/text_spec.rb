require File.join(File.dirname(__FILE__), "..", "helpers",  "spec_helper")

describe Videojuicer::Promo::Text do

   before(:all) do
    @klass = Videojuicer::Promo::Text
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "promo"
      @plural_name = "promos/text"
    end
    
    it_should_behave_like "a dependent non-resource object"
  end

end
