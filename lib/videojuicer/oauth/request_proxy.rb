=begin rdoc

  The RequestProxy is, as the name suggests, a proxy through which HTTP requests are made
  in order to have them correctly signed for verification under the OAuth protocol.
  
  More information on OAuth: http://oauth.net
  
  

=end

require 'cgi'
require 'hmac'
require File.join(File.dirname(__FILE__), 'multipart_helper')

module Videojuicer
  module OAuth

    class RequestProxy
      
      # Requests to the following ports will not include the port in the signature base string.
      # See OAuth spec 1.0a section 9.1.2 for details.
      EXCLUDED_BASE_STRING_PORTS = [80, 443].freeze
      
      include Videojuicer::Exceptions
      include Videojuicer::Configurable
            
      # Initializes a new RequestProxy object which can be used to make requests.
      # Accepts all the same options as Videojuicer::configure! as well as:
      # +token+ - The OAuth token to use in requests made through this proxy.
      # +token_secret+ - The OAuth token secret to use when encrypting the request signature.
      def initialize(options={})
        configure!(options)
      end
      
      # Makes a GET request given path and params.
      # The host will be ascertained from the configuration options.
      def get(path, params={}); make_request(:get, host, port, path, params); end
      
      # Makes a POST request given path and params.
      # The host will be ascertained from the configuration options.
      def post(path, params={}); make_request(:post, host, port, path, params); end
      
      # Makes a PUT request given path and params.
      # The host will be ascertained from the configuration options.
      def put(path, params={}); make_request(:put, host, port, path, params); end
      
      # Makes a DELETE request given path and params.
      # The host will be ascertained from the configuration options.
      def delete(path, params={}); make_request(:delete, host, port, path, params); end
      
      # Does the actual work of making a request. Returns a Net::HTTPResponse object.
      def make_request(method, host, port, path, params={})
        # Strip the files from the parameters to determine what, from the whole bundle, needs signing
        signature_params, multipart_params = split_by_signature_eligibility(params)
        
        if multipart_params.any?
          # Sign the params and include the as multipart
          multipart_params = flatten_params(
            authify_params(method, path, signature_params).deep_merge(multipart_params)
          )
          query_string = ""
        else
          # Use the query string
          query_string = authified_query_string(method, path, signature_params)
        end
        
        # Generate the HTTP Request and handle the response
        url = "#{host_stub(protocol, host, port)}#{path}"
        request = request_class_for_method(method).new("#{path}?#{query_string}")        
        # Generate the multipart body and headers
        if multipart_params.any?          
          post_body, content_type = Multipart::Post.new(multipart_params).to_multipart
          request.content_length = post_body.length
          request.content_type = content_type
          request.body = post_body
        else
          # Send a content-length on POST and PUT to avoid an HTTP 411 response
          case method
          when :post, :put
            request = request_class_for_method(method).new("#{path}")
            request.content_type = "application/x-www-form-urlencoded"
            request.body = query_string
            request.content_length = query_string.length
          end
        end
        
        
        begin
          #response = HTTPClient.send(method, url, multipart_params)
          response = Net::HTTP.start(host, port) {|http| http.request(request) }
        rescue EOFError => e
          raise "EOF error when accessing #{url.inspect}"
        rescue Errno::ECONNREFUSED => e
          raise "Could not connect to #{url.inspect}"
        end
        
        return handle_response(response, request)
      end
      
      def host_stub(_protocol=protocol, _host=host, _port=port)
        "#{_protocol}://#{_host}:#{_port}"
      end
      
      # Handles an HTTPResponse object appropriately. Redirects are followed, 
      # error states raise errors and success responses are returned directly.
      def handle_response(response, request)
        c = response.code.to_i
        case c
        when 200..399
          # Successful or redirected response
          response
        when 415
          # Validation error
          response
        when 401
          # Authentication problem
          response_error Unauthenticated, request, response
        when 403
          # Attempted to perform a forbidden action
          response_error Forbidden, request, response
        when 404
          # Resource URL not valid
          response_error NoResource, request, response
        when 406
          # Excuse me WTF r u doin
          response_error NotAcceptable, request, response
        when 411
          # App-side server error where request is not properly constructed.
          response_error ContentLengthRequired, request, response
        when 500..600
          # Remote application failure
          response_error RemoteApplicationError, request, response
        else
          response_error UnhandledHTTPStatus, request, response
        end
      end
      
      # Handles the response as an error of the desired type.
      def response_error(exception_klass, request, response)
        begin
          e = JSON.parse(response.body)
          e = e["error"]
          raise exception_klass, "#{e["message"]} \n #{(e["backtrace"] || []).join("\n")}"
        rescue JSON::ParserError
          raise exception_klass, "#{exception_klass.to_s} : Response code was #{response.code} for request: #{request.path}"
        end
        
      end
      
      # Splits a given parameter hash into two hashes - one containing all
      # string and non-binary parameters, and one containing all file/binary parameters.
      # This action is performed recursively so that:
      #   params = {:user=>{:attributes=>{:file=>some_file, :name=>"user name"}}, :foo=>"bar"}
      #   normal, multipart = split_multipart_params(params)
      #   normal.inspect # => {:user=>{:attributes=>{:name=>"user name"}}, :foo=>"bar"}
      #   multipart.inspect # => {:user=>{:attributes=>{:file=>some_file}}}
      def split_by_signature_eligibility(params, *hash_path)
        strings = {}
        files = {}
        params.each do |key, value|
          if value.is_a?(Hash)
            # Call recursively
            s, f = split_by_signature_eligibility(value, *(hash_path+[key]))
            strings = strings.deep_merge(s)
            files = files.deep_merge(f)
          else 
            # Insert it into files at the current key path if it is a binary,
            # and into strings if it is not.
            pwd = (value.respond_to?(:read))? files : strings
            hash_path.each do |component|
              pwd[component] ||= {}
              pwd = pwd[component]
            end
            pwd[key] = value
          end
        end
        return strings, files
      end
      
      def signed_url(method, path, params={})
        "#{protocol}://#{host}:#{port}#{path}?#{authified_query_string(method, path, params)}"
      end
      
      # Authifies the given parameters and converts them into a query string.
      def authified_query_string(method, path, params={})
        normalize_params(authify_params(method, path, params))
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
          :oauth_nonce=>rand(9999),
          :oauth_signature_method=>"HMAC-SHA1",
          :seed_name=>seed_name,
          :user_id=>user_id
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
      end
      
      # Calculates and returns the signature secret to be used for this proxy object.
      def signature_secret
        [consumer_secret, token_secret].collect {|e| CGI.rfc3986_escape(e.to_s)}.join("&")
      end
      
      # Returns the unencrypted signature base string for this proxy object and the 
      # given request properties.
      def signature_base_string(method, path, params)
        s = [method.to_s.upcase, "#{protocol}://#{signature_base_string_host}#{path}", normalize_params(params)].collect {|e| CGI.rfc3986_escape(e)}.join("&")
      end
      
      def signature_base_string_host
        if EXCLUDED_BASE_STRING_PORTS.include?(port.to_i)
          # Natural port. Ignore the port
          host
        else
          # Weird port. Expect a signature.
          "#{host}:#{port}"
        end
      end
      
      # Returns a string representing a normalised parameter hash. Supports nesting for
      # rails or merb-style object[attr] properties supplied as nested hashes. For instance,
      # the key 'bar inside {:foo=>{:bar=>"baz"}} will be named foo[bar] in the signature
      # and in the eventual request object.
      def normalize_params(params, *hash_path)
        flatten_params(params).sort {|a,b| a.to_s <=> b.to_s}.collect {|k, v| "#{CGI.rfc3986_escape(k)}=#{CGI.rfc3986_escape(v.to_s)}" }.join("&")
      end
      
      def flatten_params(params, *hash_path)
        op = {}
        params.sort {|a,b| a.to_s<=>b.to_s}.each do |key, value|
          path = hash_path.dup
          path << key.to_s
          
          if value.is_a?(Hash)
            op.merge! flatten_params(value, *path)
          elsif value
            key_path = path.first + path[1..(path.length-1)].collect {|h| "[#{h}]"}.join("")
            op[key_path] = value
          end
        end
        return op
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
      
    end
  end
end