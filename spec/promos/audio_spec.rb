require File.join(File.dirname(__FILE__), "..", "helpers",  "spec_helper")

describe Videojuicer::Promo::Image do

   before(:all) do
    @klass = Videojuicer::Promo::Image
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
      @singular_name = "promo"
      @plural_name = "promos/image"
      @good_attributes = {
        :role => "Voice Over",
        :href => "http://www.videojuicer.com",
        :asset_id => 1
      }
    end
    
    it_should_behave_like "a dependent non-resource object"
  end

end
