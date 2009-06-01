module Videojuicer
  class User
    include Videojuicer::Resource
    
    property :login, String
    property :password, String
    property :password_confirmation, String
    
  end
end

