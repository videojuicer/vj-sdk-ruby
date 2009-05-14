require 'rubygems'
require 'spec'
require File.join(File.dirname(__FILE__), *%w(.. lib videojuicer))

module SpecHelper
  
  
end

Spec::Runner.configure do |config|
    config.include(SpecHelper)
end