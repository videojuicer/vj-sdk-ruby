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
      end
      
      # Allow subclasses of each resource to get the attributes accessor
      def self.inherited(subclass)
        v = "@attributes"
        subclass.instance_variable_set(v, instance_variable_get(v))
      end

      
      def initialize(attrs={})
        self.attributes = default_attributes.merge(attrs)
      end
      
      def attributes=(arg)
        @attributes ||= {}
        @attributes = arg
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
        def property(name, klass, options={})
          # Can't raise twice.
          raise ArgumentError, "Property #{name} already registered." if self.attributes.include?(name)
          # Register with the class
          self.attributes[name] = {:class=>klass}.merge(options)
          # Create setter methods
          define_method name do
            attr_get(name)
          end
          
          define_method "#{name}=" do |arg|
            attr_set(name, arg)
          end
        end
        
      end
      
    end
  end
end