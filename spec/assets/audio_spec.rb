require File.join(File.dirname(__FILE__), "..", "helpers",  "spec_helper")

describe Videojuicer::Asset::Audio do
  
  before(:all) do
    @klass = Videojuicer::Asset::Audio
    configure_test_settings
    Videojuicer.enter_scope :seed_name => fixtures.seed.name, 
                            :consumer_key=>fixtures["write-master"].consumer.consumer_key,
                            :consumer_secret=>fixtures["write-master"].consumer.consumer_secret,
                            :token=>fixtures["write-master"].authorized_token.oauth_token,
                            :token_secret=>fixtures["write-master"].authorized_token.oauth_token_secret
  end
  
  after(:all) do
    Videojuicer.exit_scope
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "asset"
      @plural_name = "assets/audio"
      @good_attributes = {
        :user_id        => rand(100) + 1,
        :licensed_at    => Time.now,
        :licensed_by    => "foo, bar",
        :licensed_under => "CC BY:NC:SA",
        :published_at   => Time.now,      
        :duration       => 40200,
        :bit_rate       => 1280400,
        :format         => "MPEG Layer 3",
        :stereo         => "stereo",
        :file => File.open(File.join(File.dirname(__FILE__), "..", "files", "audio.mp3"))
      }
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
  
end