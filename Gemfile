source :gemcutter

# http://github.com/carlhuda/bundler/issues/#issue/107
# - do not change unless lib/bundler_runtime_patch tested / defunct
#gem "bundler", "0.9.26"

def gems(names, version)
  names.each { |n| gem(n, version) }
end

# DataObjects, DataMapper and Merb
gem "addressable"
gem "jeweler", "~> 1.8.3"
gem "rake", ">= 0.8.7"
gem "mash", ">= 0.0.3"
gem "randexp"
gem "ruby-hmac", ">= 0.3.2"
gem "liquid", "2.0.0"
gem "json"
gem "multipart-post", "~> 1.1.0"
gem "mime-types", "~> 1.16"

group :development do
  gem "rspec", "~> 1.3.0"
end