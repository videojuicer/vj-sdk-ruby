require File.join(File.dirname(__FILE__), "..", "helpers",  "spec_helper")

describe Videojuicer::Asset::All do
  
  before :all do
    configure_test_settings
    5.of do
      Videojuicer::Asset::Video.gen :friendly_name => "test"
    end
    @klass = Videojuicer::Asset::All
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
    
    it "should limit results" do
      @assets = @klass.all :limit => 5
      @assets.length.should == 5
    end
    
    it "should paginate" do
      @assets = @klass.all :page => 2, :limit => 10
      @assets.page_number.should == 2
      @assets.length.should == 10
    end
    
  end
  
  describe "searching" do
    it "should search" do
      @assets = @klass.all({"friendly_name.like" => "test"})
      @assets.should_not == nil
      @assets.class.should == Videojuicer::Resource::Collection
      @assets.first.friendly_name.should =~ /test/
    end
  end
  
end