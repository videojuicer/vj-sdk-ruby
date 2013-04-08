require "helpers/spec_helper"

describe Videojuicer::Seed do
  
  before(:all) do
    @klass = Videojuicer::Seed
    configure_test_settings
  end
  
  describe "instantiation" do
    it_should_behave_like "a configurable"
  end
  
  describe "getting the current seed" do
    it "should be successful" do
      s = Videojuicer::Seed.current
      s.name.should == Videojuicer.current_scope[:seed_name]
    end
  end
  
  describe "creating a seed" do
    it "should allow a seed to be created" do
      user = Videojuicer::User.new(Videojuicer::User.gen_attributes)

      token, seed = Videojuicer::Seed.create(user, {
        :name => "test-#{/\w+/.gen}-#{user.login}"
      })

      token.should_not be_empty

      seed.errors.should be_empty
      user.errors.should be_empty
    end

    it "should create a seed successfully, even when the first attempt fails" do
      user = Videojuicer::User.new(Videojuicer::User.gen_attributes)
      user.email = nil

      seed_name = "test-#{/\w+/.gen}-#{user.login}"

      token, seed = Videojuicer::Seed.create(user, {
        :name => seed_name
      })

      user.errors["email"].should_not be_empty

      token[:consumer_key].should be_nil
      token[:consumer_secret].should be_nil
      token[:recording].should be_nil
      token[:analytics].should be_nil
      
      user.email = /test(\d{1,5}+)@test\.videojuicer\.com/.gen

      token, seed = Videojuicer::Seed.create(user, {
        :name => seed_name
      })



      seed.errors.should be_empty
      user.errors.should be_empty

      token[:consumer_key].should_not be_nil
      token[:consumer_secret].should_not be_nil
    end
  end
end
