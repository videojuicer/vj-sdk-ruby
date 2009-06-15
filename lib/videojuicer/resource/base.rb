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
        base.extend(ClassMethods)        
        Inferrable.included(base)
        PropertyRegistry.included(base)
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
        return validate_response(response)
      end
      
      # The hash of errors on this object - keyed by attribute name, 
      # with the error description as the value.
      def errors=(arg); @errors = Videojuicer::Resource::Errors.new(arg); end
      def errors; @errors ||= Videojuicer::Resource::Errors.new({}); end
      def errors_on(key); errors.on(key); end
      
      # Takes a response from the API and performs the appropriate actions.
      def validate_response(response)
        attribs = (response.body.is_a?(Hash))? response.body : JSON.parse(response.body) rescue raise(JSON::ParserError, "Could not parse #{response.body.class.to_s}: \n\n #{response.body}")
        attribs.each do |prop, value|
          self.send("#{prop}=", value) rescue next
        end
        
        if e = attribs["errors"]
          self.errors = e
          return false
        else
          self.id = attribs["id"].to_i
          self.errors = {}
          return true
        end
      end
      
      # Updates the attributes and saves the record in one go.
      def update_attributes(attrs)
        self.attributes = attrs
        return save
      end
      
      # Returns the appropriate resource path for this object.
      # If the object is a new record, then the root object type path
      # will be given. If the object is not new (has an ID) then the
      # specific ID will be used.
      def resource_path
        (new_record?)? self.class.resource_path : "#{self.class.resource_path}/#{id}.js"
      end
      
      # Makes a call to the API for the current attributes on this object.
      # Overwrites the current instance attribute values.
      def reload
        raise NoResource, "Cannot load remote attributes for new records" if new_record?
        response = proxy_for(config).get(resource_path)
        return validate_response(response)
      end
      
      # Attempts to delete this record. Will raise an exception if the record is new
      # or if it has already been deleted.
      def destroy
        proxy_for(config).delete(resource_path)
      end
      
      module ClassMethods
        
        # Finds all objects matching the criteria. Also allows
        def all(options={})
          # Get reserved options
          limit = options.delete :limit
          offset = options.delete :offset
          # Get a proxy
          op = instance_proxy.get(resource_path, :limit=>limit, :offset=>offset)
          op.collect do |attrs|
            o = new
            o.attributes = attrs
            o
          end
        end
        
        # Fetches an object given an ID. Straight forward.
        def get(id)
          o = new(:id=>id)
          o.reload
          o
        end
        
        def destroy(id)
          o = new(:id=>id)
          o.destroy
        end
        
        def instance_proxy
          o = new
          o.proxy_for(o.config)
        end
      end
      
  end
end