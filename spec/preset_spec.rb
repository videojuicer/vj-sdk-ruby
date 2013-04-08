require "helpers/spec_helper"

describe Videojuicer::Preset do
  
  before(:all) do
    @klass = Videojuicer::Preset
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "preset"
      @plural_name = "presets"
    end
    
    it_should_behave_like "a RESTFUL resource model"
  end
  
  describe "formats" do
    it "should return a hash of available file, audio and video formats" do
      formats = @klass.formats
      formats.should be_kind_of(Hash)
      formats.keys.sort.should == %w(audio_formats file_formats video_formats)
    end
  end
end
