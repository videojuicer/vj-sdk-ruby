require File.join(File.dirname(__FILE__), "helpers", "spec_helper")

describe Videojuicer::Resource::PropertyRegistry do

  describe "attribute registry" do
    before(:all) do
      class ::FooAttributeRegistry
        include Videojuicer::Resource::PropertyRegistry
      
        property :integer, Integer
        property :string, String
        property :string_with_default, String, :default=>"this is the default"
      end
    
      class ::BarAttributeRegistry
        include Videojuicer::Resource::PropertyRegistry
      
        property :bar, String
      end
    
      class ::NameConditionTestRegistry
        include Videojuicer::Resource::PropertyRegistry
      
        property :name, String
        property :email, String          
      end
    
      class ::PrivatePropertyRegistry
        include Videojuicer::Resource::PropertyRegistry
      
        property :private_attr, String, :writer=>:private
        property :public_attr, String          
      end
    end
    before(:each) do
      @example_registry = ::FooAttributeRegistry.new
      @example_private_prop_registry = ::PrivatePropertyRegistry.new
    end
  
    it "registers an attribute with a type at the class scope" do
      ::FooAttributeRegistry.attributes.should include(:integer)
      ::FooAttributeRegistry.attributes.should include(:string)
      ::FooAttributeRegistry.attributes.should include(:string_with_default)
      ::FooAttributeRegistry.attributes.should_not include(:bar)
    
      ::BarAttributeRegistry.attributes.should include(:bar)
      ::BarAttributeRegistry.attributes.should_not include(:integer)
      ::BarAttributeRegistry.attributes.should_not include(:string)
      ::BarAttributeRegistry.attributes.should_not include(:string_with_default)
    end
    it "registers an attribute with a type at the instance scope" do
      @example_registry.attributes.should include(:integer)
      @example_registry.attributes.should include(:string)
      @example_registry.attributes.should include(:string_with_default)
    end
    it "respects specific defaults on properties" do
      @example_registry.string_with_default.should == "this is the default"
    end
    it "sets the default to be nil" do
      @example_registry.string.should be_nil
    end
      
    it "allows an object to be set and read directly" do
      @example_registry.string = "1234567"
      @example_registry.string.should == "1234567"
    end
  
    it "allows an object to be set and read via the indirect helper" do
      @example_registry.attr_set :string, "987654321"
      @example_registry.attr_get(:string).should == "987654321"
    end
  
    it "does not include the ID in the returnable attributes" do
      @example_private_prop_registry.returnable_attributes.should_not include(:id)
    end
    it "does not include the private attributes in the returnable attributes" do
      @example_private_prop_registry.returnable_attributes.should_not include(:private_attr)
      @example_private_prop_registry.returnable_attributes.should include(:public_attr)
    end
  
    it "allows an object to be created with a hash of attributes" do
      created = ::FooAttributeRegistry.new(:integer=>0, :string=>"0000", :string_with_default=>"1111")
      created.integer.should == 0
      created.string.should == "0000"
      created.string_with_default.should == "1111"
    end
  
    it "allows attributes to be set with a hash" do
      created = ::FooAttributeRegistry.new
      created.attributes = {:integer=>0, :string=>"0000", :string_with_default=>"1111"}
      created.integer.should == 0
      created.string.should == "0000"
      created.string_with_default.should == "1111"
    end
    it "allows attributes to be read as a hash" do
      created = ::FooAttributeRegistry.new(:integer=>0, :string=>"0000", :string_with_default=>"1111", :id=>5)
      created.attributes.should == {:integer=>0, :string=>"0000", :string_with_default=>"1111", :id=>5}
    end
  
    it "allows mass assignment with indifferent access" do
      created = ::NameConditionTestRegistry.new
      created.attributes = {"name"=>"name set", "email"=>"gooooo"}
      created.name.should == "name set"
      created.email.should == "gooooo"
    
      created = ::NameConditionTestRegistry.new
      created.attributes = {:name=>"name set", :email=>"gooooo"}
      created.name.should == "name set"
      created.email.should == "gooooo"
    end
  end
end