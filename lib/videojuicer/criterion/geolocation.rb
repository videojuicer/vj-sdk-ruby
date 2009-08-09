require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class Geolocation < Base
      
      property :country,            String
      property :region,             String    # these are things like States and Provinces for the US & Canada
      property :city,               String,   :length => 255
#      property :exclude,            Boolean,  :default => false
    end
  end
end