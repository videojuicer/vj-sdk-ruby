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
      def criteria=(object_hash)
        # TODO instantiate criteria in a useful object of some sort
        
        # Fail unless arg is an array
        # Loop over array do |mem|
          # if mem is a hash
            # instantiate as a criterion
            
            
          # if criterion object already on this policy
            # leave be
          # else
            # add_criteria(mem)
          # end
        # end
        
        # what you want to be able to do is:
        # policy.criteria.include?(some_criterion)
        @criteria = {}
        object_hash.map do |type_sym, criteria|
          @criteria[type_sym.to_sym] = 
          criteria.map do |criterion|
            Videojuicer::Criterion.model_map[type_sym.to_sym].new(criterion)
          end
        end
      end
      
      def criteria
        @criteria.values.flatten
      end
      
      %w(date_criteria geolocation_criteria request_criteria time_criteria week_day_criteria).each do |key|
        class_eval <<-DEF
          def #{key}
            @criteria[:#{key}]
          end
        DEF
      end
      
      
      def add_criteria(*criteria)
        responses = criteria.map do |criterion|
          proxy_for(config).post("#{path_for_criterion}#{criterion.class.base_path}", {:criterion => criterion.attributes})
        end
        self.reload
        responses
      end
      
      def remove_criteria(*criteria)
        responses = criteria.map do |criterion|
          proxy_for(config).delete("#{path_for_criterion}#{criterion.class.base_path}", {:criterion => criterion.attributes})
        end
        self.reload
        responses
      end
      
      def promos=(object_hash={})
        @promos = {}
        object_hash.map do |type_sym, promos|
          @promos[type_sym.to_sym] = 
          promos.map do promo|
            Videojuicer::Promo.model_map[type_sym.to_sym].new(promo)
          end
        end
      end
      
      def promos
        @promos.values.flatten
      end

      %w(audio images texts videos).each do |key|
        class_eval <<-DEF
          def #{key}
            @promos[:#{key}]
          end
        DEF
      end

      def add_promos(*promos)
        responses = promos.map do promo|
          proxy_for(config).post("#{path_for_criterion}#{criterion.class.base_path}", {:promo => promo.attributes})
        end
        self.reload
        responses
      end
      
      def remove_promos(*promos)
        responses = promos.map do |promo|
          proxy_for(config).delete("#{path_for_criterion}#{criterion.class.base_path}", {:promo => promo.attributes})
        end
        self.reload
        responses
      end
      
      def path_for_criterion
        self.class.compile_route(self.class.nesting_route,{:campaign_policy_id => self.id, :campaign_id => self.campaign_id})
      end
    end
  end
end