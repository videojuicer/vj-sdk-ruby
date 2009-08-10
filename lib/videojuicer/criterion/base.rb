module Videojuicer
  module Criterion
    def self.model_map
      { :date_criteria        => Videojuicer::Criterion::DateRange,
        :geolocation_criteria => Videojuicer::Criterion::Geolocation,
        :request_criteria     => Videojuicer::Criterion::Request,
        :time_criteria        => Videojuicer::Criterion::Time,
        :week_day_criteria    => Videojuicer::Criterion::WeekDay
      }
    end
    
    class Base
      def self.inherited(base)
        base.send(:include, Videojuicer::Resource)
        base.send(:extend, Videojuicer::Criterion::Base::ClassMethods)
        base.send(:include, Videojuicer::Criterion::Base::InstanceMethods)
      end
      
      module ClassMethods
        def singular_name
          "criterion"
        end
        
        def base_path(options={})
          "/criteria/#{self.to_s.split("::").last.snake_case}"
        end
        
        def get(*args); raise NoMethodError; end
        def all(*args); raise NoMethodError; end
        def first(*args); raise NoMethodError; end
      end
      
      module InstanceMethods
        def save(*args); raise NoMethodError; end
        def destroy(*args); raise NoMethodError; end
        def ==(other); self.attributes == other.attributes; end
        def matcher_attributes;  end
        
        def matcher_attributes
          result = {}
          self.matcher_keys.each do |key|
            result[key] = self.send(key)
          end
          return result
        end
        
        def matcher_keys
          raise NoMethodError, "Matcher Attributes needs to be implemented for #{self.class}";
        end

      end
            
    end
  end
end