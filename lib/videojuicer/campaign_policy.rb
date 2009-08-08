module Videojuicer
  class Campaign
    class CampaignPolicy
      include Videojuicer::Resource
    
      # Resource should note that this is a class within a class
      # Should treat parent class as parent resource
      
      property :presentation_id,  Integer
      property :campaign_id,      Integer
      property :created_at,       DateTime
      property :updated_at,       DateTime
      
      belongs_to :campaign
      
      attr_accessor :criteria
      def criteria=(arg)
        # TODO instantiate criteria in a useful object of some sort
        @criteria = arg
      end
        
      def add_criteria(*criteria)
      end
      
      def remove_critiera
      end
      
      def request_criteria
        @criteria[:request]
      end
      def date_criteria
        @criteria[:date_range]
      end
      def weekday_criteria
        @criteria[:weekday]
      end
      def time_criteria
        @criteria[:time]
      end
      def geolocation_criteria
        @criteria[:geolocation]
      end
    end
  end
end