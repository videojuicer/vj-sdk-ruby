require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class WeekDay < Base
      property :monday,             Boolean
      property :tuesday,            Boolean
      property :wednesday,          Boolean
      property :thursday,           Boolean
      property :friday,             Boolean
      property :saturday,           Boolean
      property :sunday,             Boolean
      property :exclude,            Boolean
      
      def matcher_keys
        [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :exclude]
      end
    end
  end
end