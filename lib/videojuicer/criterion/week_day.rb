module Videojuicer
  module Criterion
    class WeekDay
      include Videojuicer::Resource
      include Videojuicer::Exceptions
    
      property :day, Integer
      property :created_at, DateTime
      property :updated_at, DateTime

      def self.plural_name
        "criteria"
      end

      def self.singular_name
        "criterion"
      end
      
      def self.base_path
        "/criteria/week_day"
      end
    end
  end
end