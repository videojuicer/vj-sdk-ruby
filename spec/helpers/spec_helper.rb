require 'rubygems'
require 'spec'
require 'mash'
require 'yaml'
require File.join(File.dirname(__FILE__), "..", "..", "lib", "videojuicer")

require File.join(File.dirname(__FILE__), "..", "shared", "configurable_spec")

module SpecHelper
  
  def configure_test_settings(overrides={})
    Videojuicer.configure!({
      :consumer_key     => nil,
      :consumer_secret  => nil,
      :api_version      => 1,
      :protocol         => "http",
      :host             => "localhost",
      :port             => 5555
    }.merge(overrides))
  end
  
  def fixtures
    @fixtures ||= Mash.new(YAML.load(File.open(File.join(File.dirname(__FILE__), "..", "..", "core-fixtures.yml")).read))
  end
  
end

Spec::Runner.configure do |config|
    config.include(SpecHelper)
end