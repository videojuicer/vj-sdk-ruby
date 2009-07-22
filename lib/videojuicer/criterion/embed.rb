# DO NOT USE YET
module Videojuicer
  module Criterion
    class Embed
      include Videojuicer::Resource
      include Videojuicer::Exceptions

      property :created_at, DateTime
      property :updated_at, DateTime
    end
  end
end