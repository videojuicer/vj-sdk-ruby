require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class Geolocation
      
      include Videojuicer::Resource
      
      belongs_to :campaign, :class=>Videojuicer::Campaign
      
      property :campaign_id,        Integer
      property :country,            String
      property :region,             String
      property :city,               String
      property :exclude,            Boolean
      
      def self.singular_name
        "criterion"
      end
      
      def self.base_path(options={})
        "/criteria/#{self.to_s.split("::").last.snake_case}"
      end
      
      def matcher_keys
        [:country, :region, :city, :exclude]
      end

    end
  end
end