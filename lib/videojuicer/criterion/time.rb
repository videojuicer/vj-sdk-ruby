require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class Time < Base
      
      property :until, DateTime
      property :after, DateTime
      
    end
  end
end