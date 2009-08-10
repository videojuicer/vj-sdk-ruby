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
    end
  end
end