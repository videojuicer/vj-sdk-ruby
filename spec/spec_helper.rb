require 'rubygems'
require 'spec'
require File.join(File.dirname(__FILE__), *%w(.. lib videojuicer))

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
  
end

Spec::Runner.configure do |config|
    config.include(SpecHelper)
end