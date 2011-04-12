module Videojuicer
  module Resource
    module Taggable
      def tags
        tag_list.to_s.split("\0")
      end
      
      def tags=(tags)
        self.tag_list = tags.join("\0")
      end
    end
  end
end
