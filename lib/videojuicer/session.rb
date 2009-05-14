module Videojuicer
  class Session
    
    def initialize(h={})
      return ArgumentError, "Options is not a hash" unless h.is_a?(Hash)
      @default_options = h
    end
    
    def self.get_request_token(options)
      # GET tokens.js
      consumer_key = Videojuicer.default_options[:consumer_key]
      consumer_secret = Videojuicer.default_options[:consumer_secret]
      host = "http://localhost"
      uri = "/oauth/tokens.js"
      params =  {
                  :seed_name => options[:seed_name],
                  :oauth_consumer_key => consumer_key,
                  :oauth_nonce => rand(2**64),
                  :oauth_timestamp => Time.now.to_i
                }
      method = "GET"
      
      normalized_request_params = params.sort {|a,b| a.to_s<=>b.to_s}.collect {|k,v| "#{CGI.escape k.to_s}=#{CGI.escape v.to_s}" }.join("&")
      request_url = "#{host}#{uri}"

      request_elements = [method, request_url, normalized_request_params]
      request_element_string = request_elements.collect {|e| CGI.escape(e)}.join("&")
      signature_secret = "#{CGI.escape(consumer_secret)}&"

      signature_octet = HMAC::SHA1.digest(signature_secret, request_element_string)
      signature_base64 = [signature_octet].pack('m').chomp.gsub(/\n/, '')
      signature_escaped = CGI.escape(signature_base64)

      params[:oauth_signature] = signature_escaped

      request_uri = "#{uri}?#{params.collect {|k,v| "#{k}=#{v}"}.join("&")}"

      req = Net::HTTP::Get.new(request_uri)
      response = Net::HTTP.start(host.split("://").last, 4000) do |http|
        http.request(req)
      end

      response.body
    end
    

    
    def authorize!
      # GET tokens.js with magic params
      puts "not yet authorized"
    end
    
  private
    def normalize_request_params
    end
    
    def sign
    end
  end
end