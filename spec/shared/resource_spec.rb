shared_examples_for "a RESTFUL resource model" do
  
    # Expects @klass to be a reference to the model class being tested
    # Expects @singular_name to be a string containing the expected resource name, e.g. Videojuicer::User => "user"
    # Expects @plural_name to be a string containing the expected pluralised name, e.g. Videojuicer::User => "users"
    
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
      end
      before(:each) do
        @example_registry = ::FooAttributeRegistry.new
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
    end
    
    describe "inferrable names" do
      
      describe "at the class scope" do
        it "has a resource name that matches the singular class name" do
          @klass.resource_name.should == @singular_name
        end
        it "has a parameter name inferred from the resource name" do
          @klass.parameter_name.should == @singular_name
        end
        it "has a resource path that properly pluralises the resource name" do
          @klass.resource_path.should == "/#{@plural_name}"
        end 
      end
      
      describe "at the instance scope" do
        describe "with a new record" do
          it "uses the class resource path as the instance resource path"
        end
        
        describe "with an existing record" do
          it "uses an instance-specific resource path"
        end
      end
      
    end
    
    describe "a new record" do
      
    end
    
    describe "finding records" do
      
    end
    
    describe "an existing record" do
      
    end
  
end