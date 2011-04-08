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
      
      # Provides an offset when given a page number
      #
      #
      # @param [Integer] page
      # @param [Integer] limit
      #
      #
      # @return [Integer]
      #
      #
      # @api public
      def self.offset_from_page_number page, limit
        page = page.to_i
        return 0 if page == 1
        (page - 1) * limit.to_i
      end
      
      def page_count
        return 1 if limit.nil? or total.nil? or total < 1
        (total.to_f/limit.to_f).ceil
      end
      
      def page_number
        return 1 if limit.nil? or offset.nil? or offset < 1
        ((offset+1).to_f/limit.to_f).ceil
      end
      
    end 
  end
end