=begin rdoc

  The Videojuicer::Resource module is a mixin that provides RESTful model features
  to classes within the Videojuicer SDK. By including Videojuicer::Resource in a model
  class, it will gain a series of class and instance methods that *approximate* the 
  interface provided by a DataMapper or ActiveRecord-style object.



=end

module Videojuicer
  module Resource
      
      include Videojuicer::Exceptions
      include Videojuicer::Configurable
      include Videojuicer::OAuth::ProxyFactory
      include Videojuicer::Resource::Inferrable
      include Videojuicer::Resource::PropertyRegistry
            
      def self.included(base)
        base.extend(SingletonMethods)
        Inferrable.included(base)
        PropertyRegistry.included(base)
      end
      
      # Fetches an object given an ID. Straight forward.
      def self.get(id)
        
      end
      
      # Determines if this instance is a new record. For the purposes of the SDK,
      # this really means "does the item already have an ID?" - because if i reconstitute
      # a known item without first retrieving it from the API, then saving that 
      # object should push changes to the correct resource rather than creating a new
      # object.
      def new_record?
        (id)? false : true
      end
      
      # Saves the record, creating it if is new and updating it if it is not.
      # Returns TRUE on success and FALSE on fail.
      def save
        proxy = proxy_for(config)
        param_key = self.class.parameter_name
        response =  if new_record?
                      proxy.post(resource_path, param_key=>attributes)
                    else
                      proxy.put(resource_path, param_key=>attributes)
                    end
                    
        # Parse and handle response
        attrs = JSON.parse(response.body)
        if e = attrs["errors"]
          @errors = e
          return false
        else
          @errors = {}
          return true
        end
      end
      
      # The hash of errors on this object - keyed by attribute name, 
      # with the error description as the value.
      def errors
        @errors || {}
      end
      
      # Returns the appropriate resource path for this object.
      # If the object is a new record, then the root object type path
      # will be given. If the object is not new (has an ID) then the
      # specific ID will be used.
      def resource_path
        (new_record?)? self.class.resource_path : "#{self.class.resource_path}/#{id}.js"
      end
      
      # Makes a call to the API for the current attributes on this object.
      def remote_attributes
        raise NoResource, "Cannot load remote attributes for new records" if new_record?
        response = proxy_for(config).get(resource_path)
        if response.code > 400
          raise NoResource, "Problem fetching remote attributes for #{self.class.singular_name} with ID #{id}. The object does not exist on the remote API, or the remote API is down."
        else
          
        end
      end
      
      # Parses a response from the remote API and handles appropriately
      
      # Pulls attributes from the server for this object, and uses them to overwrite
      # the attributes currently set on this object.
      def reload_attributes!
        self.attributes = remote_attributes
      end
      
  end
end