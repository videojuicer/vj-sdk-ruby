require File.join(File.dirname(__FILE__),"spec_helper")

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