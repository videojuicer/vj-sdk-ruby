require "helpers/spec_helper"

describe Videojuicer::Resource::Relationships::BelongsTo do
  
  after(:all) do
    Videojuicer.exit_scope
  end
  
  before(:all) do
    configure_test_settings
    Videojuicer.enter_scope :seed_name => fixtures.seed.name, 
                            :consumer_key=>fixtures["write-master"].consumer.consumer_key,
                            :consumer_secret=>fixtures["write-master"].consumer.consumer_secret,
                            :token=>fixtures["write-master"].authorized_token.oauth_token,
                            :token_secret=>fixtures["write-master"].authorized_token.oauth_token_secret
    
    @user = Videojuicer::User.first
    @user.should be_kind_of(Videojuicer::User)
    
    class ::BelongsToExample
      include Videojuicer::Resource
      
      property :user_id, Integer
      belongs_to :user, :class=>Videojuicer::User
    end
    
    @example = ::BelongsToExample.new
    @example.user_id = @user.id
  end
  
  it "retrieves the user" do
    @example.user.id.should == @user.id
  end
  
  it "returns nil when the user_id is nonsense" do
    bad_example = ::BelongsToExample.new(:user_id=>9900000000)
    bad_example.user.should be_nil
  end
  
  it "sets the user" do
    @example.user = @user
    @example.user_id.should == @user.id
  end
  
end
