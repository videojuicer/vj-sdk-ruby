module Videojuicer
  class Campaign
    include Videojuicer::Resource
    include Videojuicer::Exceptions
    
    property :name, String
  end
end
