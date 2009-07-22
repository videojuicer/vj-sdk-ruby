module Videojuicer
  module Criterion
    class Time
      include Videojuicer::Resource
      include Videojuicer::Exceptions
    
      property :until, String
      property :after, String
      property :created_at, DateTime
      property :updated_at, DateTime

      def self.plural_name
        "criteria"
      end

      def self.singular_name
        "criterion"
      end
      
      def self.base_path
        "/criteria/time"
      end
    end
  end
end