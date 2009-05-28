shared_examples_for "a configurable" do
  
  before(:all) do
    Videojuicer.configure!(:foo=>"custom", :bar=>"not overridden")
  end
  
  before(:each) do
    Videojuicer.exit_all!
  end
  
  after(:each) do
    Videojuicer.exit_all!
  end
  
  describe "scope control" do
    before(:all) do
      @configurable_a = @candidate_klass.new
      @configurable_a.configure! :foo=>"a"
      
      @configurable_b = @candidate_klass.new
      @configurable_b.configure! :foo=>"b"
      
      @configurable_c = @candidate_klass.new
      @configurable_c.configure!({})
    end
    
    it "moves the configurable's local scope to the global scope stack" do
      Videojuicer.current_scope.should_not == @configurable_a.config
      @configurable_a.scope do |config| 
        config.should == Videojuicer.current_scope
      end
      Videojuicer.current_scope.should_not == @configurable_a.config
    end
    
    it "supports nested block behaviour" do
      @configurable_a.scope do |config_a|
        config_a[:bar].should == "not overridden"
        config_a[:foo].should == "a"
       
        Videojuicer.scopes.length.should == 2
        
        @configurable_b.scope do |config_b|
          Videojuicer.scopes.length.should == 3
          config_b[:foo].should == "b"
          config_b[:bar].should == "not overridden"
        end
        
        Videojuicer.scopes.length.should == 2
        #raise "ALL SCOPES: #{Videojuicer.scopes.inspect} \n\n\n CURRENT SCOPE: #{Videojuicer.current_scope.inspect} \n\n BLOCK CONFIG: #{config.inspect}"
           
        config_a[:foo].should == "a"
      end
    end
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
