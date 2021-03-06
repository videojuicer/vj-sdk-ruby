require "helpers/spec_helper"

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
    it_should_behave_like "a taggable"
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
      id = Videojuicer::Asset::Video.first.id
      @presentation.document_content = "{% video %}{% id #{id} %}{% endvideo %}"
      @presentation.asset_ids
      @presentation.video_assets.first.should_not == nil
      @presentation.video_assets.first.id.should == id
    end
    
    it "should should return an empty array when there are no assets of that type" do
      @presentation.document_content = "<img src=\"/my-image.png\"/>"
      @presentation.asset_ids
      @presentation.video_assets.should == []
      @presentation.video_assets.length.should == 0
    end
    
    it "should return the image asset" do
      @presentation.image_asset_id = Videojuicer::Asset::Image.first.id
      @presentation.image_asset.should_not == nil
      @presentation.image_asset.class.should == Videojuicer::Asset::Image
    end
    
    it "should also take a block and pass the image_asset to that block" do
      id = Videojuicer::Asset::Image.first.id
      @presentation.image_asset_id = id
      @presentation.image_asset do |image|
        image.id.should == id
      end
    end
    
    describe "default document_content detection" do
      
      before :each do
        @presentation = Videojuicer::Presentation.gen
        @presentation.document_content = "{% video %}{% id 8003 %}{% endvideo %}"
      end
      
      it "should know it has the default document_content" do
        @presentation.has_default_content?.should == true
      end
      
      it "should know it doesn't have the default document_content" do
        @presentation.document_content = "{% image %}{% id 1 %}{% endimage %}"
        @presentation.has_default_content?.should == false
      end
      
      it "should return false if there is any markup in the document_content" do
        @presentation.document_content = "{% image %}{% id 1 %}{% endimage %} <br/>"
        @presentation.has_default_content?.should == false
      end
      
      it "should return false if there are any other smil tags in the document" do
        @presentation.document_content = "{% video %}{% id 323 %}{% delivery progressive-only %}{% endvideo %}"
        @presentation.has_default_content?.should == false
      end
      
      it "should return false if the document_content is nil" do
        @presentation.document_content = nil
        @presentation.has_default_content?.should == false
      end
      
    end
    
  end
  
  
  
end
