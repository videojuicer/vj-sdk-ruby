require "helpers/spec_helper"

describe Videojuicer::Criterion::Request do

   before(:all) do
    @klass = Videojuicer::Criterion::Request
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "criterion"
      @plural_name = "criteria/request"
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end

end
