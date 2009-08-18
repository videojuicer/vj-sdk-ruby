require File.join(File.dirname(__FILE__), "..", "helpers", "spec_helper")

describe Videojuicer::Criterion::Geolocation do

   before(:all) do
    @klass = Videojuicer::Criterion::Geolocation
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "criterion"
      @plural_name = "criteria/geolocation"
    end
    
    it_should_behave_like "a dependent non-resource object"
  end

end
