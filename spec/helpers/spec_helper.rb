require 'rubygems'
require 'spec'
require 'mash'
require 'yaml'
require File.join(File.dirname(__FILE__), "..", "..", "lib", "videojuicer")

require File.join(File.dirname(__FILE__), "..", "shared", "configurable_spec")
require File.join(File.dirname(__FILE__), "..", "shared", "resource_spec")

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
  
  def cycle_attributes(attrs, exempt_keys=[])
    r = rand(99999)
    attrs.inject({}) do |memo, (key, value)| 
      memo.merge({
        key =>  if exempt_keys.include?(key)
                  value
                elsif value.respond_to?(:read)
                  value
                elsif value.is_a?(Date) or value.is_a?(DateTime) or value.is_a?(Time)
                  value
                else 
                  value.to_s.gsub(/\d+/, r.to_s)
                end
      })
    end
  end
  
  def strip_files(attrs)
    
  end
  
end

Spec::Runner.configure do |config|
    config.include(SpecHelper)
end