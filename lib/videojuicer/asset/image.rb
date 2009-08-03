require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Asset
    class Image < Base
      property :width,    Integer # pixels
      property :height,   Integer # pixels
    end
  end
end