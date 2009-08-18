require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::Campaign::CampaignPolicy do
  
  before(:all) do
    @klass = Videojuicer::Campaign::CampaignPolicy
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "campaign_policy"
      @plural_name = "campaign_policies"
      @fixed_attributes = [:campaign_id]
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