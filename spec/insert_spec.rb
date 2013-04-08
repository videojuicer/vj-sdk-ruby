require "helpers/spec_helper"

describe Videojuicer::Insert do
  
  before(:all) do
    @klass = Videojuicer::Insert
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "insert"
      @plural_name = "inserts"
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
  
end
