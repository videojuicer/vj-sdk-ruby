class CGI
  class << self
    
    def rfc3986_escape(str)
      escape(str).gsub("+", "%20")
    end
    def rfc3986_unescape(str)
      unescape(str)
    end
    
  end
end