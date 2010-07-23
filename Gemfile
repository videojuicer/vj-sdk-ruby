source :gemcutter

# http://github.com/carlhuda/bundler/issues/#issue/107
# - do not change unless lib/bundler_runtime_patch tested / defunct
gem "bundler", "0.9.26"

def gems(names, version)
  names.each { |n| gem(n, version) }
end

# DataObjects, DataMapper and Merb
gem "merb-core", "1.1.0.pre"
gem "jeweler", ">= 1.4.0"
gem "rake", ">= 0.8.7"
gem "rspec", ">= 1.3.0"
gem "mash"
gem "randexp"
gem "ruby-hmac"
gem "liquid", "2.0.0"