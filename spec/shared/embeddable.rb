shared_examples_for "an embeddable" do
  
  # Requires same variables to be set as the shared resource spec.
  
  before(:all) do
    @record = @klass.gen
    @record.save.should be_true
  end
  
  describe "getting the oembed payload" do
    before(:all) do
      @oembed_payload = @record.oembed_payload(700, 700)
    end
    
    it "should be parsed from JSON" do
      @oembed_payload.should be_kind_of(Hash)
    end
    
    it "should have the embed source" do
      @oembed_payload["html"].should_not be_blank
    end
  end
  
  describe "getting the embed code" do
    before(:all) do
      @src = @record.embed_code(700, 700)
    end
    
    it "should be populated" do
      @src.should_not be_blank
    end
  end
  
end