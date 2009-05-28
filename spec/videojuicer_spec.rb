require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe "Videojuicer SDK" do
  
  describe "initialization with an options hash" do
    before(:all) do
      Videojuicer.configure!(
        :consumer_key => "consumer_key",
        :consumer_secret => "consumer_secret",
        :api_version => 100,
        :host => "host",
        :port => 100
      )
    end    
    after(:all) do
      Videojuicer.unconfigure!
    end
    
    it "respects the :consumer_key option" do
      Videojuicer.default_options[:consumer_key].should == "consumer_key"
    end
    it "respects the :consumer_secret option" do
      Videojuicer.default_options[:consumer_secret].should == "consumer_secret"
    end
    it "respects the :api_version option" do
      Videojuicer.default_options[:api_version].should == 100
    end
    it "respects the :host option" do
      Videojuicer.default_options[:host].should == "host"
    end
    it "respects the :port option" do
      Videojuicer.default_options[:port].should == 100
    end
  end
  
  describe "scope management" do
     before(:all) do
        @default = {
          :consumer_key => "consumer_key",
          :consumer_secret => "consumer_secret",
          :api_version => 100,
          :host => "host",
          :port => 100
        }
        Videojuicer.configure!(@default)
      end
    
    describe "with no scope" do      
      it "should respond false to in_scope?" do
        Videojuicer.in_scope?.should be_false
      end
      
      it "should give the given defaults as the current scope" do
        Videojuicer.current_scope.should == Videojuicer::DEFAULTS.merge(@default)
      end
    end
    
    describe "entering a scope" do
      before(:all) do
        @scope1 = {:api_version=>"in scope 1", :scope_1_included=>true}
        Videojuicer.enter_scope(@scope1)
      end
      
      it "should respond true to in_scope?" do
        Videojuicer.in_scope?
      end
      it "should give the current scope config in response to current_scope" do
        Videojuicer.current_scope.should == Videojuicer::DEFAULTS.merge(@default).merge(@scope1)
      end
      
      describe "and then entering another scope" do
        before(:all) do
          @scope2 = {:api_version=>"in scope 2", :scope_2_included=>true}
          Videojuicer.enter_scope(@scope2)
        end
        
        it "should respond true to in_scope?" do
          Videojuicer.in_scope?
        end
        it "should inherit from the current scope" do
          Videojuicer.current_scope.should == Videojuicer::DEFAULTS.merge(@default).merge(@scope1).merge(@scope2)
        end
      end
      
      describe "and then exiting a scope" do
        before(:all) do
          @current_scope = Videojuicer.current_scope
          @length_at_current_scope = Videojuicer.scopes.length
          Videojuicer.enter_scope(:entered_scope=>1)
          Videojuicer.current_scope.should_not == @current_scope
          Videojuicer.exit_scope
        end
        
        it "should reduce the scope stack length" do
          Videojuicer.scopes.length.should == @length_at_current_scope
        end
        
        it "should restore the current_scope to the previous value" do
          Videojuicer.current_scope.should == @current_scope
        end
      end
    end
    
  end
  
  
  describe "initialization with defaults" do
    before(:all) do
      Videojuicer.unconfigure!
      Videojuicer.default_options.should == Videojuicer::DEFAULTS
    end
    
    it "provides a default host" do
      Videojuicer.default_options[:port].should_not be_nil
    end
    
    it "provides a default port" do
      Videojuicer.default_options[:host].should_not be_nil
    end
  end
  
end