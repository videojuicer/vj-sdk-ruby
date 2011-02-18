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
      
      class ::DateRegistry
        include Videojuicer::Resource::PropertyRegistry
        
        property :date, DateTime
      end
      
      class ::InvalidAttributeRegistry
        
        include Videojuicer::Resource::PropertyRegistry
        
        property :foo, String
      end
      
    end
    before(:each) do
      @example_registry = ::FooAttributeRegistry.new
      @example_private_prop_registry = ::PrivatePropertyRegistry.new
      @date_registry = ::DateRegistry.new
      
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
    
    it "registers an attribute as being dirty when the attribute is set" do
      @r = ::FooAttributeRegistry.new
      @r.attr_set :string, "987654321"
      @r.attr_dirty?(:string).should be_true
      @r.attr_dirty?(:integer).should be_false
    end
    
    it "clears the dirty attributes when clean_dirty_attributes! is called" do
      @r = ::FooAttributeRegistry.new
      @r.attr_set :string, "987654321"
      @r.attr_dirty?(:string).should be_true
      @r.clean_dirty_attributes!
      @r.attr_dirty?(:string).should be_false
    end
    
    it "provides the dirty attributes for submission as a hash" do
      @r = ::FooAttributeRegistry.new
      @r.integer = 0
      @r.dirty_attribute_keys.should == [:string_with_default, :integer]
      @r.dirty_attributes.should == {:string_with_default=>"this is the default", :integer=>0}
    end
  
    it "converts attributes to a date when a string is passed into a datetime object" do
      @date_registry.date = "2009-07-01 13:14:15"
      @date_registry.date.should be_kind_of(DateTime)
      @date_registry.date.year.should == 2009
      @date_registry.date.month.should == 7
      @date_registry.date.day.should == 1
      @date_registry.date.hour.should == 13
      @date_registry.date.min.should == 14
      @date_registry.date.sec.should == 15
    end
  
    it "does not include the ID in the returnable attributes" do
      @example_private_prop_registry.returnable_attributes.should_not include(:id)
    end
    it "does not include the private attributes in the returnable attributes" do
      @example_private_prop_registry.public_attr = "foo" # dirty the attributes
      @example_private_prop_registry.private_attr = "bar"
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
    
    it "allows you to set arbitrary attributes" do
      lambda { ::InvalidAttributeRegistry.new({:bar => 'bar'}) }.should_not raise_error(NoMethodError)
    end
    
    it "should store invalid attributes in a separate hash" do
      invalid = ::InvalidAttributeRegistry.new({:bar => 'bar'})
      invalid.invalid_attributes.should_not == {}
    end
    
  end
end