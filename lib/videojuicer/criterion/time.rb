module Videojuicer
  module Criterion
    class Time
      
      include Videojuicer::Resource
      
      belongs_to :campaign, :class=>Videojuicer::Campaign
      
      property :campaign_id, Integer
      property :until, DateTime
      property :from, DateTime
      
      def self.singular_name
        "criterion"
      end
      
      def self.base_path(options={})
        "/criteria/#{self.to_s.split("::").last.snake_case}"
      end
      
      def matcher_keys
        [:until, :from]
      end
    end
  end
end