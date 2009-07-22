module Videojuicer
  module Criterion
    class Geolocation
      include Videojuicer::Resource
      include Videojuicer::Exceptions
    
      property :city,     String
      property :region,   String
      property :country,  String
      #property :exclude,  Boolean
      property :created_at, DateTime
      property :updated_at, DateTime

      def self.plural_name
        "criteria"
      end

      def self.singular_name
        "criterion"
      end
      
      def self.base_path
        "/criteria/geolocation"
      end
    end
  end
end