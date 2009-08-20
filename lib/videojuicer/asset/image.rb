require File.join(File.dirname(__FILE__), "base")

module Videojuicer
  module Asset
    class Image < Base
      property :width,  Integer, :writer => :private # pixels
      property :height, Integer, :writer => :private # pixels
    end
  end
end