module Videojuicer
  class User
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
    property :name, String
    property :login, String
    property :email, String
    property :password, String
    property :password_confirmation, String
    property :created_at, DateTime
    property :updated_at, DateTime
    
    # Authenticates the given login and password and returns
    # a user if the details are correct. Requires a Master token.
    def self.authenticate(login, password)
      proxy = Videojuicer::OAuth::RequestProxy.new
      begin
        jobj = proxy.get("/users/authenticate.json", :login=>login, :password=>password)
        o = new(:id=>jobj["id"])
        o.reload
        return o
      rescue NoResource =>e
        return nil
      end
    end
    
    # Manage virtual attributes that are not sent back to the API
    attr_accessor :roles
    def has_role?(symbol)
      roles.include?(symbol.to_s)
    end
    
  end
end