module Videojuicer
  module Criterion
    class DateRange
      include Videojuicer::Resource
      include Videojuicer::Exceptions
    
      property :until, DateTime
      property :after, DateTime
      property :created_at, DateTime
      property :updated_at, DateTime

      def self.plural_name
        "criteria"
      end

      def self.singular_name
        "criterion"
      end
      
      def self.base_path
        "/criteria/date_range"
      end
    end
  end
end