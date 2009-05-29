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
        base.extend(SingletonMethods)
        attr_accessor :attributes
      end
      
      def initialize(attrs={})
        self.attributes = default_attributes.merge(attrs)
      end
      
      def attributes
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
        d
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
          raise ArgumentError, "Property #{name} already registered." if attributes.include?(name)
          # Register with the class
          @@attributes ||= {}
          @@attributes[name] = {:class=>klass}.merge(options)
          # Create setter methods
          define_method name do
            attr_get(name)
          end
          
          define_method "#{name}=" do |arg|
            attr_set(name, arg)
          end
        end
        
        def attributes
          @@attributes ||= {}
          @@attributes
        end
        
      end
      
    end
  end
end