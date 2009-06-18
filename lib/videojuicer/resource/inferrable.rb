=begin rdoc
  =Inferred names

  Inferrable contains methods used by Resources to automagically determine various
  API parameters from the name of the including class.

  E.g. 

  class Videojuicer::Movie
    include Videojuicer::Resource # Inferrable is included by this line
  end

  Videojuicer::Movie.resource_name #=> "movie" (The base name)
  Videojuicer::Movie.parameter_name #=> "movie" (The key used when crafting parameter keys e.g. movie[title])
  Videojuicer::Movie.resource_path #=> "/movies" (The base URI used to retrieve data related to objects of this tyle)
  Videojuicer::Movie.resource_path(id_of_movie) #=> "/movies/id_of_movie.json" (The base URI used to retrieve data related to objects of this tyle)

  m = Videojuicer::Movie.new
  m.resource_path #=> "/movies" (The URI that will be used to )

  m = Videojuicer::Movie.first
  m.id #=> 500, for example
  m.resource_path #=> "/movies/500.json"
=end

module Videojuicer
  module Resource
    module Inferrable
  
      def self.included(base)
        base.extend(SingletonMethods)
      end
      
      module SingletonMethods
        
        # Returns the lowercased, underscored version of the including class name.
        # e.g. Videojuicer::ExampleModel.singular_name => "example_model"
        def singular_name
          @singular_name ||=  self.to_s.split("::").last.
                              gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
                              gsub(/([a-z\d])([A-Z])/,'\1_\2').
                              tr("-", "_").
                              downcase
        end
        
        # Returns the plural version of the underscored singular name. This method,
        # when compared directly and fairly to something like ActiveSupport's inflection
        # module, is an idiot. You would be best to treat it as one.
        def plural_name
          (singular_name.match(/s$/))? "#{singular_name}es" : "#{singular_name}s"
        end
        
        # The name used to identify this resource to the API, and in responses from the API.
        def resource_name
          singular_name
        end

        # The name used to send parameters to the API. For instance, if a model named Cake has
        # an attribute is_lie, and the parameter name of Cake is "cake", this attribute will be
        # sent to the API as a parameter named cake[is_lie] with the appropriate value.
        def parameter_name
          singular_name
        end

        # The root path for requests to the API. By default this is inferred from the plural name
        # e.g. Videojuicer::Movie uses /movies as the resource_path.
        def resource_path
          "/#{plural_name}"
        end
      end
      
      
    end
  end
end