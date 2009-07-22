# DO NOT USE YET
module Videojuicer
  module Criterion
    class Affiliate
      include Videojuicer::Resource
      include Videojuicer::Exceptions

      property :created_at, DateTime
      property :updated_at, DateTime

    
      def self.singular_name
        "criteria"
      end
      
      def self.base_path
        "/criteria/affilate"
      end
    end
  end
end