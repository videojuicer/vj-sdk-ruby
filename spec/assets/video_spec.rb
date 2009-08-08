require File.join(File.dirname(__FILE__), "..", "helpers",  "spec_helper")

describe Videojuicer::Asset::Video do
  
  before(:all) do
    @klass = Videojuicer::Asset::Video
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
      @plural_name = "assets/video"
      @good_attributes = {
        :user_id           => rand(100) + 1,
        :licensed_at       => Time.now,
        :licensed_by       => "foo, bar",
        :licensed_under    => "CC BY:NC:SA",
        :published_at      => Time.now,      
        :duration          => 14990,
        :audio_bit_rate    => 354200,
        :audio_format      => "QDesign Music 2",
        :audio_sample_rate => 22050,
        :audio_stereo      => "mono",
        :video_bit_rate    => 1000000,
        :video_format      => "Sorenson Video 3 Decompressor",
        :width             => 240,
        :height            => 180,
        :file => File.open(File.join(File.dirname(__FILE__), "..", "files", "video.mov"))
      }
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
  
end