require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::Seed do
  
  before(:all) do
    @klass = Videojuicer::Seed
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "getting the current seed" do
    it "should be successful" do
      s = Videojuicer::Seed.current
      s.name.should == Videojuicer.current_scope[:seed_name]
    end
  end
  
end