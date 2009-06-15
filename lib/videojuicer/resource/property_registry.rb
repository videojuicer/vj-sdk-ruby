=begin rdoc

  = Property Registry
  
  This module allows model classes to register properties that have setter and getter methods,
  and are earmarked to be included in calls between instances of those classes and the API.
  
  Properties are registered using a DataMapper-style syntax (ActiveRecord-style autodiscovery not
  being possible).

=end

module Videojuicer
  module Resource
    module PropertyRegistry

      def self.included(base)        
        # Class-level inheritable reader
        base.extend(SingletonMethods)
        base.class_eval do
          @attributes = {}
          class << self
            attr_accessor :attributes
          end
        end
        base.property :id, Integer
      end
      
      # Allow subclasses of each resource to get the attributes accessor
      def self.inherited(subclass)
        v = "@attributes"
        subclass.instance_variable_set(v, instance_variable_get(v))
      end

      
      def initialize(attrs={})
        self.attributes = default_attributes
        self.attributes = attrs
      end
      
      def attributes
        @attributes ||= {}
        @attributes
      end
      
      def attributes=(arg)
        raise ArgumentError, "Attributes must be set as a Hash" unless arg.is_a?(Hash)
        arg.each do |key, value|
          self.send("#{key}=", value)
        end
      end
      
      def default_attributes
        d = {}
        self.class.attributes.each do |key, props|
          d[key] = props[:default] ||  nil
        end
        return d
      end
      
      def attr_get(key)
        attributes[key]
      end
      
      def attr_set(key, value)
        attributes[key] = value
      end
      
      module SingletonMethods
        
        # Registers an attribute using a datamapper-style syntax.
        # Creates setter and getter methods
        def property(prop_name, klass, options={})
          # Can't raise twice.          
          prop_name = prop_name.to_sym
          raise ArgumentError, "Property #{prop_name} already registered." if self.attributes.include?(prop_name)
          
          # Register with the class
          self.attributes[prop_name] = {:class=>klass}.merge(options)
          # Create setter methods
          define_method prop_name do
            attr_get(prop_name)
          end
          
          define_method "#{prop_name}=" do |arg|
            attr_set(prop_name, arg)
          end
        end
        
      end
      
    end
  end
end