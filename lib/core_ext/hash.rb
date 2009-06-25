class Hash

  # Returns a new hash just like this one, but with all the string keys expressed as symbols.
  # Also applies to hashes within self.
  # Based on an implementation within Rails 2.x, thanks Rails!
  def deep_symbolize
    target = dup    
    target.inject({}) do |memo, (key, value)|
      value = value.deep_symbolize if value.is_a?(Hash)
      memo[(key.to_sym rescue key) || key] = value
      memo
    end
  end
    
  # Merges self with another hash, recursively.
  # 
  # This code was lovingly stolen from some random gem:
  # http://gemjack.com/gems/tartan-0.1.1/classes/Hash.html
  # 
  # Thanks to whoever made it.
  def deep_merge(hash)
    target = dup
    
    hash.keys.each do |key|
      if hash[key].is_a? Hash and self[key].is_a? Hash
        target[key] = target[key].deep_merge(hash[key])
        next
      end      
      target[key] = hash[key]
    end    
    target
  end
  
  def to_xml
    inject("") do |memo, (key, value)|
      memo << "<#{key}>#{(value.respond_to?(:to_xml))? value.to_xml : value}</#{key}>"
    end
  end

end