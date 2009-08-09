require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Criterion
    class Request < Base
      
      property :referrer,           String, :nullable => false
      property :exclude,            Boolean
      
    end
  end
end