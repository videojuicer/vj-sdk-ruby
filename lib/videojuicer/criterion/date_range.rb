require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class DateRange < Base
      
      property :until, DateTime
      property :from, DateTime
      
      def matcher_keys
        [:until, :from]
      end
    end
  end
end