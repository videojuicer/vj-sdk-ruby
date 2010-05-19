require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class WeekDay
      
      include Videojuicer::Resource
      
      belongs_to :campaign, :class=>Videojuicer::Campaign
      
      property :campaign_id,        Integer
      property :monday,             Boolean
      property :tuesday,            Boolean
      property :wednesday,          Boolean
      property :thursday,           Boolean
      property :friday,             Boolean
      property :saturday,           Boolean
      property :sunday,             Boolean
      property :exclude,            Boolean
      
      def self.singular_name
        "criterion"
      end
      
      def self.base_path(options={})
        "/criteria/#{self.to_s.split("::").last.snake_case}"
      end
      
      def matcher_keys
        [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :exclude]
      end
    end
  end
end