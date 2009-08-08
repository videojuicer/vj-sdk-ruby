shared_examples_for "a dependent non-resource object" do

=begin
  Dependent objects are non-resource objects that are typically members of a collection that is an attribute of a resource object.
  
  Rather than a classic has_many/belongs_to relationship between RESTful objects, these objects are expressed as properties on the parent object - 
  they are *dependent* and unable to exist on their own.
  
  In the SDK, helper classes for dependent objects are provided to allow creation and validation, but they do not allow dependent objects to be
  saved as first-order objects. Instead, a parent object must be given the dependent object to add to its collection attribute.
  
  This model currently applies to Criteria and Promo objects.  

  Expects @klass to be a reference to the model class being tested
  Expects @parent to be a valid object ready to have objects of type @klass added to it.
  Expects @singular_name to be a string containing the expected resource name, e.g. Videojuicer::User => "user"
  Expects @plural_name to be a string containing the expected pluralised name, e.g. Videojuicer::User => "users"
  Expects @good_attributes to be a hash of attributes for objects of the tested type that will successfully create a valid object.
=end
  
  it_should_behave_like "a model"

  it "has no get class method" do
    lambda {@klass.get(9)}.should raise_error(NoMethodError)
  end
  it "has no all class method" do
    lambda {@klass.all}.should raise_error(NoMethodError)
  end
  it "has no first class method" do
    lambda {@klass.first}.should raise_error(NoMethodError)
  end
  it "has no save instance method" do
    lambda {@klass.new.save}.should raise_error(NoMethodError)
  end
  it "has no destroy instance method" do
    lambda {@klass.new.destroy}.should raise_error(NoMethodError)
  end
  

end