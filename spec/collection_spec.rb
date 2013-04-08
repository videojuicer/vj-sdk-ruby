require "helpers/spec_helper"

describe Videojuicer::Resource::Collection do

  before(:all) do
    @objects = [:foo]*100
    @collection = Videojuicer::Resource::Collection.new(@objects[0..9], 155, 10, 10)
  end
  
  it "is instantiated correctly" do    
    @collection.should be_kind_of(Videojuicer::Resource::Collection)
    @collection.total.should == 155
    @collection.offset.should == 10
    @collection.limit.should == 10
  end
  
  it "can count the number of pages" do
    @collection.page_count.should == 16
  end
  
  it "can tell the current page" do
    @collection.page_number.should == 2
  end
  
  it "reports page 1 when tested with a zero offset" do
    c = Videojuicer::Resource::Collection.new(@objects[0..9], 155, 0, 10)
    c.page_number.should == 1
  end
  
  it "reports page 1 when there are zero items" do
    c = Videojuicer::Resource::Collection.new(@objects[0..9], 0, 0, 10)
    c.page_number.should == 1
  end
  
  it "pagination copes with a nil limit" do
    collection = Videojuicer::Resource::Collection.new(@objects[0..9], 155, 17, nil)
    collection.page_count.should == 1
    collection.page_number.should == 1
  end
  
  it "provides a correct offset for a page number and limit when the page is 1" do
    offset = Videojuicer::Resource::Collection.offset_from_page_number 1, 20
    offset.should == 0
  end
  
  it "should provide a correct offset" do
    offset = Videojuicer::Resource::Collection.offset_from_page_number 2, 20
    offset.should == 20
  end
  
  it "should be able to take a string as a page and limit argument" do
    offset = Videojuicer::Resource::Collection.offset_from_page_number "2", "20"
    offset.should == 20
  end
  
  
end
