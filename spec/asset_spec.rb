require "helpers/spec_helper"

describe Videojuicer::Asset do

  before :all do
    configure_test_settings
    
    @klass = Videojuicer::Asset
    @assets = @klass.types.map do |t|
      
      t.all.each { |a| a.destroy }
      
      10.of { t.gen } << t.gen(:friendly_name => "to_filter")
    end.flatten
  end
  
  after :all do
    begin
      @assets.each { |a| a.destroy }
    rescue
    end
  end
  
  describe "listing assets of all types" do
    it "should list all assets" do
      @assets = @klass.all
      @assets.class.should == Videojuicer::Resource::Collection
      @assets.total.should >= @assets.size
    end
    
    it "should limit results" do
      @assets = @klass.all(:limit => 5)
      @assets.length.should == 5
    end
    
    it "should paginate" do
      @assets = @klass.all(:limit => 10, :page => 2)
      @assets.page_count.should > 2
      @assets.page_number.should == 2
      @assets.length.should == 10
    end
    
    it "should filter by friendly_name" do
      @klass.all("friendly_name.like" => "to_filter").total.should == @klass.types.size
    end
  end
end
