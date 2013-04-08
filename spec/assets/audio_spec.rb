require "helpers/spec_helper"

describe Videojuicer::Asset::Audio do
  
  before(:all) do
    @klass = Videojuicer::Asset::Audio
    @preset_params = {:derived_type => "Audio", :file_format => "mp3"}
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "asset"
      @plural_name = "assets/audio"
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
  it_should_behave_like "an asset"
end
