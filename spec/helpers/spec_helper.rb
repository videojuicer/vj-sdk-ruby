require 'rubygems'
#require 'spec'
require 'yaml'


Bundler.require :development

unless defined?(Mash)
  # Don't require Mash twice. It causes cranial trauma.
  require 'mash'
end

begin
  require 'randexp'
rescue LoadError
  raise "The Randexp gem is required in order to run the test suites, but it is not required to use the SDK in production environments. To run the tests, please `sudo gem install randexp`"
end

require "lib/videojuicer"

require "shared/configurable"
require "shared/model"
require "shared/resource"
require "shared/embeddable"
require "shared/dependent"
require "shared/asset"
require "shared/taggable"

# Load the fixture helper
require File.join(File.dirname(__FILE__), "spec_fixtures")

module SpecHelper
  
  def configure_test_settings(overrides={})
    Videojuicer.configure!({
      :api_version      => 1,
      :protocol         => "http",
      :host             => "localhost",
      :port             => 6666,
      :consumer_key     => fixtures["write-master"]["consumer"]["consumer_key"],
      :consumer_secret  => fixtures["write-master"]["consumer"]["consumer_secret"],
      :token            => fixtures["write-master"]["authorized_token"]["oauth_token"],
      :token_secret     => fixtures["write-master"]["authorized_token"]["oauth_token_secret"],
      :seed_name        => fixtures["seed"]["name"]
    }.merge(overrides))
  end
  
  def fixtures
    fixture_path = File.join(core_path, "sdk_fixtures.yml")
    fixture_src = File.open(fixture_path).read
    @core_fixtures ||= Mash.new(YAML.load(fixture_src))
  end
  
  def core_path
    File.join(File.dirname(__FILE__), "..", "..", "..", "vj-core")
  end
  
end

RSpec.configure do |config|
    config.include(SpecHelper)
end
