=begin

  Configurable is a mixin intended for internal use within the SDK.
  
  It provides a suite of helper methods to objects that use the scoped configuration
  system within the root Videojuicer module.
  
  Objects that are Configurable have a local configuration, which will always be 
  respected, and a shared configuration object which merges the current configuration
  scope with the local configuration.
  
  For instance:
  
    # Assuming that the Videojuicer default configuration is a simple hash containing {:in_a_scope=>false}
  
    a_configurable.configure! :foo=>"bar" # config[:foo] will ALWAYS == "bar" for this object.
    a_configurable.local_config #=> {:foo=>"bar"}
    a_configurable.config #=> {:in_a_scope=>false, :foo=>"bar"}
    
    # Now let's enter a scope:
    Videojuicer.enter_scope :in_a_scope=>true, :foo=>"not bar"
    
    a_configurable.local_config #=> {:foo=>"bar"}
    a_configurable.config #=> {:in_a_scope=>true, :foo=>"bar"}
    
    # And leave it again..
    Videojuicer.exit_scope
    
    a_configurable.local_config #=> {:foo=>"bar"}
    a_configurable.config #=> {:in_a_scope=>false, :foo=>"bar"}

=end

module Videojuicer
  module Configurable
    
    attr_accessor :local_config
    
    # Sets the local configuration for this Configurable.
    # The local configuration will always be respected regardless of the 
    # current controller scope.
    def configure!(options={})
      self.local_config = options
    end
    
    # Returns the shared configuration, which is the current
    # controller scope merged with the local config.
    def config
      Videojuicer.current_scope.merge(local_config || {})
    end
    
    # Executes a block of code within the scope of this Configurable's
    # local configuration.
    #
    # This is achieved by pushing the local configuration onto the controller's
    # scope stack, executing the given block and then exiting the scope. During
    # this procedure the local configuration on this object will remain unchanged.
    # 
    # Example:
    # Videojuicer.configure! :bar=>"baz"
    # configurable_a.configure! :foo=>"a"
    # configurable_b.configure! :foo=>"b"
    # 
    # configurable_a.scope do |config|
    #   config[:bar] #=> "baz"
    #   config[:foo] #=> "a"
    #   
    #   configurable_b.scope do |config|
    #     config[:foo] #=> "b"
    #   end
    #
    #   config[:foo] #=> "a"
    # end
    def scope(&block)
      Videojuicer.enter_scope local_config
      block_out = block.call(Videojuicer.current_scope)
      Videojuicer.exit_scope
      return block_out
    end
    
    # Retrieves the host from the configuration options.
    def host; config[:host]; end
    # Retrieves the port from the configuration options.
    def port; config[:port]; end
    # Retrieves the consumer_key from the configuration options.
    def consumer_key; config[:consumer_key]; end
    # Retrieves the consumer_secret from the configuration options.
    def consumer_secret; config[:consumer_secret]; end
    # Retrieves the token from the configuration options.
    def token; config[:token]; end
    # Retrieves the token_secret from the configuration options.
    def token_secret; config[:token_secret]; end
    # Retrieves the api_version from the configuration options.
    def api_version; config[:api_version]; end
    # Retrieves the protocol from the configuration options.
    def protocol; config[:protocol]; end
    # Retrieves the seed name from the configuration options.
    def seed_name; config[:seed_name]; end
    # Retrieves the user_id from the configuration options. Master tokens can be used to authenticate as any user.
    def user_id; config[:user_id]; end
    
  end
end