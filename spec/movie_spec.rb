#require File.join(File.dirname(__FILE__), "helpers", "spec_helper")
#
#describe Videojuicer::Movie do
#  
#  before(:all) do
#    @klass = Videojuicer::Movie
#  end
#  
#  describe "instantiation" do
#    it_should_behave_like "a configurable"
#  end
#  
#  describe "general interface:" do
#    before(:all) do
#      @singular_name = "movie"
#      @plural_name = "movies"
#      @good_attributes = {
#        :title=>"Movie title #{rand 99999}",
#        :abstract=>"Movie abstract #{rand 99999}",
#        :author=>"Bob Anon"
#      }
#    end
#    
#    it_should_behave_like "a RESTFUL resource model"
#  end
#  
#  
#end