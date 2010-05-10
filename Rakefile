require 'rubygems'
require 'bundler'
require 'net/http'

# BUNDLER TRANSFORM!
require 'lib/bundler_runtime_patch' # Andre's OMG MEGA HAX to allow DataMapper to require successfully
Bundler.require :default, :vj_core_dependencies

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "vj-sdk"
    gem.summary = "Videojuicer core-sdk"
    gem.email = "dan@videojuicer.com"
    gem.homepage = "http://github.com/videojuicer/vj-sdk"
    gem.authors = ["danski", "thejohnny", "knowtheory", "sixones", "btab"]
    
    # Declare dependencies
    gem.add_dependency "json", ">= 1.0"
    gem.add_dependency "ruby-hmac", ">= 0.3.2"
    gem.add_dependency "mash", ">= 0.0.3"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', 'spec/spec.opts']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do
  task :sdk do
    Rake::Task["spec"].execute
  end
end
task :default => :"spec:sdk"

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "vj-sdk #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "provide a console like merb -i or script/console"
task :console do
  exec "irb -r irb/completion -r lib/videojuicer.rb -r lib/sdk_connection_harness.rb"
end
