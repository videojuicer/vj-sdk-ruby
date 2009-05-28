=begin rdoc
  
  ProxyFactory is a mixin that provides a convenience DSL for creating
  new RequestProxy objects. It is intended for internal use within the SDK.

=end

module Videojuicer
  module OAuth
    module ProxyFactory
      
      def proxy_for(options={})
        Videojuicer::OAuth::RequestProxy.new(options)
      end
      
    end
  end
end