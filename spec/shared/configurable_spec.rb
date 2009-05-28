shared_examples_for "a configurable" do
  
  before(:all) do
    Videojuicer.configure!(:foo=>"custom", :bar=>"not overridden")
  end
  
  it "gets the configuration defaults from those already set on the Videojuicer module" do
    obj = @candidate_klass.new
    obj.config[:foo].should == "custom"
  end
  
  it "can override defaults from the Videojuicer configuration hash" do
    obj = @candidate_klass.new(:bar=>"overridden")
    obj.config[:bar].should == "overridden"
  end
  
  %w(host port consumer_key consumer_secret token token_secret api_version seed_name protocol).each do |attr|
    it "provides a direct access method for the #{attr} given in the configuration" do
      obj = @candidate_klass.new((attr.to_sym)=>"#{attr} was set")
      obj.send(attr).should == "#{attr} was set"
    end
  end
  
end
