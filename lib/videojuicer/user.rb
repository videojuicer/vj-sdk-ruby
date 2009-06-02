module Videojuicer
  class User
    include Videojuicer::Resource
    
    property :name, String
    property :login, String
    property :email, String
    property :password, String
    property :password_confirmation, String
    property :created_at, DateTime
    property :updated_at, DateTime
    
  end
end