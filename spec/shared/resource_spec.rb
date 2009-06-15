shared_examples_for "a RESTFUL resource model" do
  
    # Expects @klass to be a reference to the model class being tested
    # Expects @singular_name to be a string containing the expected resource name, e.g. Videojuicer::User => "user"
    # Expects @plural_name to be a string containing the expected pluralised name, e.g. Videojuicer::User => "users"
    # Expects @good_attributes to be a hash of attributes for objects of the tested type that will successfully create a valid object.
    
    before(:all) do
      Videojuicer.configure!  :seed_name => fixtures.seed.name, 
                              :consumer_key=>fixtures["write-master"].consumer.consumer_key,
                              :consumer_secret=>fixtures["write-master"].consumer.consumer_secret,
                              :token=>fixtures["write-master"].authorized_token.oauth_token,
                              :token_secret=>fixtures["write-master"].authorized_token.oauth_token_secret
    end
    
    
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
    
    describe "inferrable naming" do
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
    
    describe "a new record" do
      before(:each) do
        @record = @klass.new
      end
      
      it "returns true to #new_record?" do
        @record.new_record?.should be_true
      end
      
      it "uses the class resource path as the instance resource path" do
        @record.resource_path.should == @klass.resource_path
      end
      
      it "raises an exception when trying to pull attributes remotely" do
        lambda {@record.reload}.should raise_error(Videojuicer::Exceptions::NoResource)
      end
      
      describe "being saved" do        
        describe "successfully" do
          before(:all) { @successful = @klass.new(@good_attributes); @saved = @successful.save }
          
          it "returns true" do
            @saved.should == true
          end
          it "does not set any errors on the object" do
            @successful.errors.should be_empty
          end
          it "gets an ID" do
            @successful.id.should be_kind_of(Integer)
          end
        end
        describe "unsuccessfully" do
          before(:all) do 
            @bad_attributes = @good_attributes.inject({}) do |memo, (key,value)|
              memo.merge({key=>""})
            end
            @fail = @klass.new(@bad_attributes)
            @saved = @fail.save
          end
          
          it "returns false" do
            @saved.should be_false
          end
          it "sets errors on the object" do
            @fail.errors.should be_kind_of(Hash)
            @fail.errors.should_not be_empty
          end
          it "does not get an ID" do
            @fail.id.should be_nil
          end
        end
      end
    end
    
    describe "finding a record by ID" do
      before(:all) do        
        @record = @klass.new(cycle_attributes(@good_attributes))
        @record.save.should be_true
        @found = @klass.get(@record.id)
      end
      
      it "gets all the attributes" do
        attrs = @found.attributes.dup
        attrs.delete(:id)
        attrs = attrs.reject {|k,v| !v}
        attrs.should_not be_empty
      end
    end
    
    describe "listing records" do
      before(:all) do
        @list = @klass.all
      end
      
      it "should return an array" do
        @list.should be_kind_of(Array)
      end
    end
    
    describe "finding a record by conditions" do
      it "should translate a conditions hash to filterable format"
    end
    
    describe "an existing record" do
      before(:each) do
        @record = @klass.new(cycle_attributes(@good_attributes))
        @record.save.should be_true
      end
      
      it "returns false to #new_record?" do
        @record.new_record?.should be_false        
      end
      
      it "uses an instance-specific resource path" do
        @record.resource_path.should == "/#{@plural_name}/#{@record.id}.js"
      end
      
      it "reloads from the remote API successfully" do
        @record.reload.should be_true
      end
      
      it "saves successfully" do
        @record.save.should be_true
      end
    end
    
    describe "deleting a record" do
      before(:each) do
        @record = @klass.new(cycle_attributes(@good_attributes))
        @record.save.should be_true
      end
      
      it "destroys the record" do
        @record.destroy
        lambda {@record.reload}.should raise_error(Videojuicer::Exceptions::NoResource)
      end
    end
  
end