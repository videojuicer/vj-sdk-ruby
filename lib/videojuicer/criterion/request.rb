module Videojuicer
  module Criterion
    class Request
      include Videojuicer::Resource
      include Videojuicer::Exceptions

      property :referrer, String
      property :created_at, DateTime
      property :updated_at, DateTime

      def self.plural_name
        "criteria"
      end

      def self.singular_name
        "criterion"
      end
      
      def self.base_path
        "/criteria/request"
      end
    end
  end
end