shared_examples_for "a RESTFUL resource model" do
  
    # Expects @klass to be a reference to the model class being tested
    # Expects @singular_name to be a string containing the expected resource name, e.g. Videojuicer::User => "user"
    # Expects @plural_name to be a string containing the expected pluralised name, e.g. Videojuicer::User => "users"
    # Expects @good_attributes to be a hash of attributes for objects of the tested type that will successfully create a valid object.
    
	it_should_behave_like "a model"

    before(:all) do
    	@fixed_attributes ||= []
    end
    
    describe "a new record" do
      before(:each) do
        @record = @klass.new
      end
           
      describe "being saved" do   
        describe "successfully" do
          before(:all) do 
            @successful = @klass.new(@good_attributes)
            raise @successful.errors.inspect unless @successful.valid?
            @successful.valid?.should be_true
            @saved = @successful.save
          end
          
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
              memo.merge({key=>(@fixed_attributes.include?(key)? value : "")})
            end
            @fail = @klass.new(@bad_attributes)
            @saved = @fail.save
          end
          
          it "is not #valid?" do
            @fail.valid?.should be_false
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
        @random_attributes ||= cycle_attributes(@good_attributes, @fixed_attributes)
        @record = @klass.new(@random_attributes)
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
      
      it "should return a collection object" do
        @list.should be_kind_of(Videojuicer::Resource::Collection)
      end
      it "should add the pagination options to the collection object" do
        @list.limit.should be_kind_of(Numeric)
      end
      
      describe "with pagination settings" do
        before(:all) do
          @paginated_list = @klass.all(:limit=>5)
        end
        
        it "should return a collection object" do
          @paginated_list.should be_kind_of(Videojuicer::Resource::Collection)
        end
        it "returns the proper amount of objects" do
          @paginated_list.limit.should == 5
        end
      end
    end
    
    describe "finding a record by conditions" do
      it "should translate a conditions hash to filterable format"
    end
    
    describe "an existing record" do
      before(:all) do
        @random_attributes ||= cycle_attributes(@good_attributes, @fixed_attributes)
        @record = @klass.new(@random_attributes)
        @record.save.should be_true
      end
      
      it "returns false to #new_record?" do
        @record.new_record?.should be_false        
      end
      
      it "uses an instance-specific resource path" do
        @record.resource_path.should =~ /\/#{@plural_name}\/#{@record.id}\.json$/
      end
      
      it "reloads from the remote API successfully" do
        @record.reload.should be_true
      end
      
      it "saves successfully" do
        saved = @record.save
        @record.errors.should == {}
        saved.should be_true
      end
    end
    
    describe "deleting a record" do
      before(:each) do
        @random_attributes ||= cycle_attributes(@good_attributes, @fixed_attributes)
        @record = @klass.new(@random_attributes)
        @record.save.should be_true
      end
      
      it "destroys the record" do
        @record.destroy
        lambda {@record.reload}.should raise_error(Videojuicer::Exceptions::NoResource)
      end
    end
  
end