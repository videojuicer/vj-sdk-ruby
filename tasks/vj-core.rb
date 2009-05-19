=begin

  Prepares the vj-core development environment. Runs automatically before spec.

=end

class SDKTestController
  class << self

    attr_accessor :server_thread

    def core_directory
      File.join(File.dirname(__FILE__), "..", "..", "vj-core")
    end    
    
  end
end


namespace :videojuicer do
  namespace :core do
    
    task :setup do
      Rake::Task['videojuicer:core:start'].invoke
    end
    
    task :cleanup do
      
    end
    
    task :start do
      require 'mongrel'
      SDKTestController.server_thread = Thread.new do
        Dir.chdir(SDKTestController.core_directory) do
          puts "Starting vj-core from #{Dir.pwd}"
          Merb.start :merb_root=>Dir.pwd, :port=>5555, :reload_classes=>true, :name=>"vj-sdk-test", :verbose=>false, :adapter=>"mongrel", :testing=>false
        end
      end
    end
    
    task :status do
      p = Merb::Config.log_stream
      p.rewind;
      
      puts p.inspect
      puts `ps aux | grep merb`
      puts `curl -I 0.0.0.0:5555`
    end
    
    task :stop do
      
    end
    
  end
end

