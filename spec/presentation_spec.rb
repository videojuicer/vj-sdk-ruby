require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::Presentation do
  
  before(:all) do
    @klass = Videojuicer::Presentation
    configure_test_settings
  end

  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "general interface:" do
    before(:all) do
      @singular_name = "presentation"
      @plural_name = "presentations"
    end
    
    it_should_behave_like "a RESTFUL resource model"
    it_should_behave_like "an embeddable"
  end
  
  describe "fetching asset ids" do
    
    before :each do
      @presentation = @klass.gen
      5.of { Videojuicer::Asset::Video.create :file_name => 'foo.mp4' }
      5.of { Videojuicer::Asset::Image.create :file_name => 'foo.png' }
    end
    
    it "should fetch asset ids" do
      @presentation.document_content = "{% video %}{% id 1 %}{% endvideo %}"
      @presentation.asset_ids.should_not == nil
      @presentation.asset_ids[:video].first.should == '1'
    end
  
    it "should fetch longer asset ids" do
        @presentation.document_content = "{% video %}{% id 8003 %}{% endvideo %}"
        @presentation.asset_ids.should_not == nil
        @presentation.asset_ids[:video].first.should == '8003'
    end
    
    it "should deal with non-standard document_content" do
      @presentation.document_content = "{% video %}         {% id 200 %}         {% endvideo %} {% audio %} {% id 122 %} {% endaudio %}" 
      @presentation.asset_ids.should_not == nil
      @presentation.asset_ids[:video].first.should == '200'
      @presentation.asset_ids[:audio].first.should == '122'
    end
    
    it "should deal with xml too" do
      @presentation.document_content = '<seq><par>{% video %}         {% id 200 %}         {% endvideo %}{% image %}         {% id 200 %}         {% endimage %}</par><par>{% video %}         {% id 200 %}         {% endvideo %}</par></seq>'
      @presentation.asset_ids.should_not == nil
      @presentation.asset_ids[:video].first.should == '200'
      @presentation.asset_ids[:image].first.should == '200'
    end
    
    it "should also fetch assets" do
      @presentation.document_content = "{% video %}{% id 1 %}{% endvideo %}"
      @presentation.asset_ids
      @presentation.video_assets.first.should_not == nil
      @presentation.video_assets.first.id.should == 1
    end
    
    it "should return the image asset" do
      @presentation.image_asset_id = Videojuicer::Asset::Image.first.id
      @presentation.image_asset.should_not == nil
      @presentation.image_asset.class.should == Videojuicer::Asset::Image
    end
    
    it "should also take a block and pass the image_asset to that block" do
      @presentation.image_asset_id = Videojuicer::Asset::Image.first.id
      @presentation.image_asset do |image|
        image.id.should == 1
      end
    end
    
  end
  
  
  
end