require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class Request
      
      include Videojuicer::Resource
      
      belongs_to :campaign, :class=>Videojuicer::Campaign
      
      property :campaign_id,         Integer
      property :referrer,           String, :nullable => false
      property :exclude,            Boolean
      
      def self.singular_name
        "criterion"
      end
      
      def self.base_path(options={})
        "/criteria/#{self.to_s.split("::").last.snake_case}"
      end
      
      def matcher_keys
        [:referrer, :exclude]
      end
    end
  end
end