=begin rdoc
  Videojuicer::Resource::Collection is an array extension returned by many common actions within
  the Videojuicer SDK. Any request that returns paginated data, or a subset of your query results,
  will return a Collection object containing the object subset, with some additional pagination
  data.
=end

module Videojuicer
  module Resource
    class Collection < ::Array
      
      attr_accessor :limit
      attr_accessor :offset
      attr_accessor :total
      
      def initialize(objects, total, offset, limit)
        clear
        objects.each {|o| self << o }
        self.total = total
        self.offset = offset
        self.limit = limit
      end
      
      def page_count
        (total.to_f/limit.to_f).ceil
      end
      
      def page_number
        (offset.to_f/limit.to_f).ceil
      end
      
    end 
  end
end