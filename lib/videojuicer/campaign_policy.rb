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
        criteria.map do |criterion|
          proxy_for(config).post("#{path_for_criterion}#{criterion.class.base_path}", {:criterion => criterion.attributes})
        end
      end
      
      def remove_criteria(*criteria)
        criteria.map do |criterion|
          proxy_for(config).delete("#{path_for_criterion}#{criterion.class.base_path}", {:criterion => criterion.attributes})
        end
      end
      
      def path_for_criterion
        self.class.compile_route(self.class.nesting_route,{:campaign_policy_id => self.id, :campaign_id => self.campaign_id})
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