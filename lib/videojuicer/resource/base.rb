=begin rdoc

  The Videojuicer::Resource module is a mixin that provides RESTful model features
  to classes within the Videojuicer SDK. By including Videojuicer::Resource in a model
  class, it will gain a series of class and instance methods that *approximate* the 
  interface provided by a DataMapper or ActiveRecord-style object.



=end

module Videojuicer
  module Resource
      
      include Videojuicer::Configurable
      include Videojuicer::OAuth::ProxyFactory
      include Videojuicer::Resource::Inferrable
      include Videojuicer::Resource::PropertyRegistry
      
      def self.included(base)
        base.extend(SingletonMethods)
        Inferrable.included(base)
        PropertyRegistry.included(base)
      end
      
  end
end