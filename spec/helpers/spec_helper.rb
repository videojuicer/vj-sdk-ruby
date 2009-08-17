require 'rubygems'
require 'spec'
require 'mash'
require 'yaml'
begin
  require 'randexp'
rescue LoadError
  raise "The Randexp gem is required in order to run the test suites, but it is not required to use the SDK in production environments. To run the tests, please `sudo gem install randexp`"
end

require File.join(File.dirname(__FILE__), "..", "..", "lib", "videojuicer")

require File.join(File.dirname(__FILE__), "..", "shared", "configurable_spec")
require File.join(File.dirname(__FILE__), "..", "shared", "model_spec")
require File.join(File.dirname(__FILE__), "..", "shared", "resource_spec")
require File.join(File.dirname(__FILE__), "..", "shared", "embeddable_spec")
require File.join(File.dirname(__FILE__), "..", "shared", "dependent_spec")

# Load the fixture helper
require File.join(File.dirname(__FILE__), "spec_fixtures")

module SpecHelper
  
  def configure_test_settings(overrides={})
    Videojuicer.configure!({
      :consumer_key     => nil,
      :consumer_secret  => nil,
      :api_version      => 1,
      :protocol         => "http",
      :host             => "localhost",
      :port             => 6666
    }.merge(overrides))
  end
  
  def fixtures
    @fixtures ||= Mash.new(YAML.load(File.open(File.join(File.dirname(__FILE__), "..", "..", "core-fixtures.yml")).read))
  end
  
end

Spec::Runner.configure do |config|
    config.include(SpecHelper)
end