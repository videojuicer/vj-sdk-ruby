=begin rdoc

  The RequestProxy is, as the name suggests, a proxy through which HTTP requests are made
  in order to have them correctly signed for verification under the OAuth protocol.
  
  More information on OAuth: http://oauth.net
  
  

=end

require 'cgi'
require 'hmac'

module Videojuicer
  module OAuth
    class RequestProxy
      
      attr_accessor :config
      
      # Initializes a new RequestProxy object which can be used to make requests.
      # Accepts all the same options as Videojuicer::configure! as well as:
      # +token+ - The OAuth token to use in requests made through this proxy.
      # +token_secret+ - The OAuth token secret to use when encrypting the request signature.
      def initialize(options={})
        self.config = Videojuicer.default_options.merge(options)
      end
      
      # Makes a GET request given path and params.
      # The host will be ascertained from the configuration options.
      def get(path, params); make_request(:get, host, port, path, params); end
      
      # Makes a POST request given path and params.
      # The host will be ascertained from the configuration options.
      def post(path, params); make_request(:post, host, port, path, params); end
      
      # Makes a PUT request given path and params.
      # The host will be ascertained from the configuration options.
      def put(path, params); make_request(:put, host, port, path, params); end
      
      # Makes a DELETE request given path and params.
      # The host will be ascertained from the configuration options.
      def delete(path, params); make_request(:delete, host, port, path, params); end
      

      
      
      # Does the actual work of making a request. Returns a Net::HTTPResponse object.
      def make_request(method, host, port, path, params)
        klass = request_class_for_method(method)
        request = method_klass.new(path + ("?#{authified_query_string(method, path, params)}"))
        begin
          response =  Net::HTTP.start(host, port) do |http|
                        block.call(http, request)
                      end
        rescue Errno::ECONNREFUSED => e
          raise "Could not connect to #{uri.inspect}"
        end
        return response
      end
      
      # Authifies the given parameters and converts them into a query string.
      def authified_query_string(method, path, params)
        p = authify_params(method, path, params)
        p.collect {|k,v| "#{CGI.escape k}=#{CGI.escape v}"}.join("&")
      end
      
      # Takes a set of business parameters you want sent to the provider, and merges them
      # with the proxy configuration to produce a set of parameters that will be accepted
      # by the OAuth provider.
      def authify_params(method, path, params)
        params = {
          :oauth_consumer_key=>consumer_key,
          :oauth_token=>token,
          :api_version=>api_version,
          :oauth_timestamp=>Time.now.to_i,
          :oauth_nonce=>rand(9999)
        }.merge(params)
        params.delete_if {|k,v| (!v) or (v.to_s.empty?) }
        params[:oauth_signature] = signature(method, path, params)
        return params
      end
      
      # Calculates and returns the encrypted signature for this proxy object and the
      # given request properties.
      def signature(method, path, params)
        base = signature_base_string(method, path, params)
        signature_octet = HMAC::SHA1.digest(signature_secret, base)
        signature_base64 = [signature_octet].pack('m').chomp.gsub(/\n/, '')
        CGI.escape(signature_base64)
      end
      
      # Calculates and returns the signature secret to be used for this proxy object.
      def signature_secret
        [consumer_secret, token_secret].collect {|e| CGI.escape(e.to_s)}.join("&")
      end
      
      # Returns the unencrypted signature base string for this proxy object and the 
      # given request properties.
      def signature_base_string(method, path, params)
        [method.to_s.upcase, "#{host}#{path}", normalize_params(params)].collect {|e| CGI.escape(e)}.join("&")
      end
      
      # Returns a string representing a normalised parameter hash. Supports nesting for
      # rails or merb-style object[attr] properties supplied as nested hashes. For instance,
      # the key 'bar inside {:foo=>{:bar=>"baz"}} will be named foo[bar] in the signature
      # and in the eventual request object.
      def normalize_params(params, *hash_path)
        params.sort {|a,b| a.to_s<=>b.to_s}.collect do |key, value|
          path = hash_path.dup
          path << key.to_s
          if value.is_a?(Hash)
            CGI.unescape normalize_params(value, *path)
          else
            key_path = path.first + path[1..(path.length-1)].collect {|h| "[#{h}]"}.join("")
            "#{CGI.escape "#{key_path}"}=#{CGI.escape value.to_s}"
          end
        end.join("&")
      end
      
      # Returns the Net::HTTPRequest subclass needed to make a request for the given method.
      def request_class_for_method(m, in_module=Net::HTTP)
        case (m.is_a?(Symbol) ? m : m.downcase.to_sym rescue :get)
        when :post
          in_module::Post
        when :put
          in_module::Put
        when :head
          in_module::Head
        when :delete
          in_module::Delete
        else
          in_module::Get
        end
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
      
    end
  end
end