require 'rubygems'
require 'merb-core'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "vj-sdk"
    gem.summary = %Q{TODO}
    gem.email = "dan@videojuicer.com"
    gem.homepage = "http://github.com/danski/vj-sdk"
    gem.authors = ["danski", "thejohnny", "knowtheory", "sixones"]
    
    # Declare dependencies
    gem.add_dependency "oauth", ">= 0.3.3"
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
    require 'tasks/vj-core'
    Rake::Task["videojuicer:core:setup"].invoke
    Rake::Task["spec"].invoke
    Rake::Task["videojuicer:core:cleanup"].invoke
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

