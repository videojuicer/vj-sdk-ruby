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
  
  it "should fetch asset ids" do
    presentation = @klass.gen
    presentation.document_content = "{% video %}{% id 1 %}{% endvideo %}" 
#    $stdout.puts presentation.asset_ids.inspect
    presentation.asset_ids.should_not == nil
    presentation.asset_ids[:video].first.should == '1'
  end
  
  it "should fetch longer asset ids" do
      presentation = @klass.gen
      presentation.document_content = "{% video %}{% id 8003 %}{% endvideo %}" 
    $stdout.puts presentation.asset_ids.inspect
      presentation.asset_ids.should_not == nil
      presentation.asset_ids[:video].first.should == '8003'
  end
  
  
  
end