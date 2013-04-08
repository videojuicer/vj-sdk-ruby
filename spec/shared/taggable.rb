shared_examples_for "a taggable" do
    
  before(:each) do
    @object = @klass.new
    @tags = %w(a b,c d"f)
  end
  
  describe "tags" do
    it "should be an empty array by default" do
      @object.tags.should == []
    end
    
    it "should split incoming tag lists on nulls" do
      @object.tag_list = @tags.join("\0")
      @object.tags.should == @tags
    end
    
    it "should support assignment, serializing into a null-separated tag list" do
      @object.tags = @tags
      @object.tag_list.should == @tags.join("\0")
      @object.tags.should == @tags
    end
  end
  
end