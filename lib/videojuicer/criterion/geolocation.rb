require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class Geolocation < Base
      
      property :country,            String
      property :region,             String
      property :city,               String
      property :exclude,            Boolean
      
      def matcher_keys
        [:country, :region, :city, :exclude]
      end

    end
  end
end