require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::Campaign::CampaignPolicy do
  
  before(:all) do
    @klass = Videojuicer::Campaign::CampaignPolicy
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
      @singular_name = "campaign_policy"
      @plural_name = "campaign_policies"
      string_mash = (("A".."z").to_a + ("a".."z").to_a)
      @good_attributes = {
        :name => (0..rand(75)).map{ string_mash[rand(string_mash.size - 1)] }.join
      }
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
  describe "adding policies" do
  
  end
  
  describe "removing policies" do
  
  end
  
  describe "adding promos" do
  
  end
  
  describe "removing promos" do
  
  end
  
  
end