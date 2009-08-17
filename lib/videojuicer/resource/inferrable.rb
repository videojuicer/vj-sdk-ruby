=begin rdoc
  =Inferred names

  Inferrable contains methods used by Resources to automagically determine various
  API parameters from the name of the including class.

  E.g. 

  class Videojuicer::Presentation
    include Videojuicer::Resource # Inferrable is included by this line
  end

  Videojuicer::Presentation.resource_name #=> "presentation" (The base name)
  Videojuicer::Presentation.parameter_name #=> "presentation" (The key used when crafting parameter keys e.g. presentation[title])
  Videojuicer::Presentation.resource_path #=> "/presentations" (The base URI used to retrieve data related to objects of this tyle)
  Videojuicer::Presentation.resource_path(id_of_presentation) #=> "/presentations/id_of_presentation.json" (The base URI used to retrieve data related to objects of this tyle)

  m = Videojuicer::Presentation.new
  m.resource_path #=> "/presentations" (The URI that will be used to )

  m = Videojuicer::Presentation.first
  m.id #=> 500, for example
  m.resource_path #=> "/presentations/500.json"
=end

module Videojuicer
  module Resource
    module Inferrable
  
      def self.included(base)
        base.extend(SingletonMethods)
        base.send :include, InstanceMethods
      end
      
      module InstanceMethods
        # Returns the appropriate resource path for this object.
        # If the object is a new record, then the root object type path
        # will be given. If the object is not new (has an ID) then the
        # specific ID will be used.
        def resource_path(action=nil, route_options={})
          route_options = {:id=>id}.merge(route_options) unless new_record?
          r = self.class.resource_route(action, route_options)
          self.class.compile_route(r, attributes)
        end
      end
      
      module SingletonMethods
        
        def compile_route(mask, properties={})
          properties = properties.deep_stringify
          result = []
          mask.split("/").each do |member|
            if member[0..0] == ":"
              result << (properties[member.delete(":")])
            else
              result << member
            end            
          end
          "#{result.join("/")}"
        end
        
        # Nested resources are inferred from the class hierarchy:
        # Something.parent_class #=> nil
        # Something::Else.parent_class #=> Something        
        # Monkeys::Are::Delicious
        def containing_class
          c = self.to_s.split("::"); c.pop
          (c.any?)? Object.full_const_get(c.join("::")) : nil
        end
        
        # The route fragment under which nested resources should be mapped.
        def nesting_route
          r = ["/#{plural_name}/#{nesting_route_key}"]
          r = ([(self.containing_class.nesting_route rescue nil)] + r).compact.join("")
        end
        
        # The key used by other models when referring to this one in resource routes. User.nesting_route_key == ":user_id"
        def nesting_route_key
          ":#{resource_name}_id"
        end
        
        # Returns the lowercased, underscored version of the including class name.
        # e.g. Videojuicer::ExampleModel.singular_name => "example_model"
        def singular_name
          @singular_name ||=  self.to_s.split("::").last.
                              gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
                              gsub(/([a-z\d])([A-Z])/,'\1_\2').
                              tr("-", "_").
                              downcase.snake_case
        end
        
        # Returns the plural version of the underscored singular name. This method,
        # when compared directly and fairly to something like ActiveSupport's inflection
        # module, is an idiot. You would be best to treat it as one.
        def plural_name
          if singular_name.match(/y$/)
          	return singular_name.gsub(/y$/, "ies")
          end          
          # Fall back to the simplest rules
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

        # The path to this class's resource given the desired action route.
        # Returned as a mask with replaceable keys e.g. /fixed/fixed/:replaceme/fixed
        def resource_route(action=nil, route_options={})
          id = route_options.delete(:id)
          action_stem = (id)? "/#{id}" : ""
          action_stem += (action)? "/#{action}" : ""
          action_stem += ".json" unless action_stem.empty?
          "#{base_path(route_options)}#{action_stem}"
        end
        
        # The root route for requests to the API. By default this is inferred from the plural name
        # e.g. Videojuicer::Presentation uses /presentations as the resource_path.
        def base_path(options={})
  	      options = {
  	      	:nested=>true
  	      }.merge(options)
          r = "/#{plural_name}"
          r = "#{self.containing_class.nesting_route rescue nil}#{r}" if options[:nested]
          return r
        end
        
      end
      
      
    end
  end
end