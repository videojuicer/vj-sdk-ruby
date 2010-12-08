require File.join(File.dirname(__FILE__), "helpers",  "spec_helper")

describe Videojuicer::Assets do
  
  before :all do
    @klass = Videojuicer::Assets
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "listing assets of all types" do
    
    it "should list assets" do
      @assets = @klass.all
      @assets.should_not == nil
      @assets.class.should == Videojuicer::Resource::Collection
    end
  end
  
  describe "searching" do
    it "should search" do
      @assets = @klass.all({"friendly_name.like" => "test"})
      @assets.should_not == nil
      @assets.class.should == Videojuicer::Resource::Collection
    end
  end
  
end