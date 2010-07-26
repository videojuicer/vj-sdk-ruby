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
    
  end
  
  
  
end