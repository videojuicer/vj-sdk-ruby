require File.join(File.dirname(__FILE__), "helpers",  "spec_helper")

describe Videojuicer::Assets do
  
  before :each do
    @klass = Videojuicer::Assets
    @preset_params = {:derived_type => "Audio", :file_format => "mp3"}
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "listing assets of all types" do
    
    it "should list assets" do
      @assets = Videojuicer::Assets.all
      p @assets
      @assets.class.should == Array
    end
  end
  
end