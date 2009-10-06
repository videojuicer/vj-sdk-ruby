shared_examples_for "an asset" do
  before(:all) do
    @preset = (@preset_params.nil? ? nil : Videojuicer::Preset.create(@preset_params.merge(:name => /\w{10}/.gen)))
    @user = Videojuicer::User.first
    raise "asset spec suite assumes at least one common user exists" if @user.nil?
  end
  
  after(:all) do
    @preset.destroy unless @preset.nil?
  end
  
  before(:each) do
    @original = @klass.gen unless @preset.nil?
  end
  
  after(:each) do
    @original.destroy unless @preset.nil?
    @derived.destroy unless @derived.nil?
  end
  
  it "external derivation should succeed" do
    unless @preset.nil?
      @derived = @klass.gen
      @derived.derived_internally.should == nil
      @derived.set_derived(@original, @preset)
      @derived.should be_valid
      @derived.derived_internally.should == false
    end
  end
  
  it "internal derivation should succeed" do
    unless @preset.nil?
      @derived = @original.derive(@preset)
      @derived.should be_valid
      @derived.id.should_not == @original.id
      @derived.derived_internally.should == true
    end
  end
end