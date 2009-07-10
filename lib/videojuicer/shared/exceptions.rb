module Videojuicer
  module Exceptions
   
    class NotAuthorised < ::StandardError; end
    
    # Raised when a method requiring instance-specific data from the remote API
    # is called on an object that does not exist remotely.
    class NoResource < ::RuntimeError; end
    
    # Raised when a record cannot be saved because it has attributes that are well rubbish.
    class InvalidRecord < ::RuntimeError; end
    
    # Raised when a request is completely buggered by the remote API.
    class RemoteApplicationError < ::StandardError; end
    
    # Raised when the remote resource refuses to carry out an action.
    class Forbidden < ::StandardError; end
    
  end
end