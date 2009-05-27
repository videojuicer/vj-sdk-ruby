require 'rubygems'
require 'spec'
require 'mash'
require 'yaml'
require File.join(File.dirname(__FILE__), "..", "lib", "videojuicer")

module SpecHelper
  
  def configure_test_settings
    Videojuicer.configure!(
      :consumer_key     => nil,
      :consumer_secret  => nil,
      :api_version      => 1,
      :host             => "http://localhost",
      :port             => 5000
    )
  end
  
  def fixtures
    @fixtures ||= Mash.new(YAML.load(File.open(File.join(File.dirname(__FILE__), "..", "core-fixtures.yml")).read))
  end
  
end

Spec::Runner.configure do |config|
    config.include(SpecHelper)
end