shared_examples_for "a model" do

=begin

  vj-sdk model classes, whether for first-order resources or for dependent objects, offer a suite of common functionality
  
  this test covers those methods.

=end

    # Expects @klass to be a reference to the model class being tested
    # Expects @singular_name to be a string containing the expected resource name, e.g. Videojuicer::User => "user"
    # Expects @plural_name to be a string containing the expected pluralised name, e.g. Videojuicer::User => "users"
    # Expects @good_attributes to be a hash of attributes for objects of the tested type that will successfully create a valid object.
    
    describe "a new record" do
      before(:each) do
        @record = @klass.new
      end
      
      it "returns true to #new_record?" do
        @record.new_record?.should be_true
      end
      
      it "raises an exception when trying to pull attributes remotely" do
        lambda {@record.reload}.should raise_error(Videojuicer::Exceptions::NoResource)
      end
      
      it "returns false to #valid?" do
        @record.valid?.should be_false
      end
    end
  
    describe "inferrable naming" do
      before(:all) do
        class ::Nester
          include Videojuicer::Resource::Inferrable
        
          class Nested
            include Videojuicer::Resource::Inferrable
          
            class Leaf
              include Videojuicer::Resource::Inferrable
            end
          end
        end
      end
    
      it "has a resource name that matches the singular class name" do
        @klass.resource_name.should == @singular_name
      end
      it "has a parameter name inferred from the resource name" do
        @klass.parameter_name.should == @singular_name
      end
      it "has a resource path that properly pluralises the resource name" do
        @klass.resource_route.should =~ /\/#{@plural_name}/
      end
      
      it "ascertains the containing class" do
        ::Nester.containing_class.should be_nil
        ::Nester::Nested.containing_class.should == ::Nester
        ::Nester::Nested::Leaf.containing_class.should == ::Nester::Nested
      end
      
      it "builds a nested route" do
        ::Nester::Nested::Leaf.resource_route.should == "/nesters/:nester_id/nesteds/:nested_id/leafs"
      end
      
      it "compiles a route" do
        ::Nester.compile_route("/foo/bar/:foo/:bar/foo", :foo=>"OMG", :bar=>"ROFLMAO").should == "/foo/bar/OMG/ROFLMAO/foo"
      end
    end

end