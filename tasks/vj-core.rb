=begin

  Prepares the vj-core development environment. Runs automatically before spec.

=end

require 'net/http'

class SDKTestHarness
  class << self

    attr_accessor :server_thread
    attr_accessor :fixtures

    def core_directory
      File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "vj-core"))
    end
    
    def start!
      stop! if server_thread
      self.server_thread = Thread.new do
        puts "Starting vj-core from #{core_directory}"
        Merb.start  :merb_root=>core_directory, 
                    :port=>port, 
                    :reload_classes=>true, 
                    :name=>"vj-sdk-test", 
                    :verbose=>false, 
                    :adapter=>"mongrel", 
                    :testing=>true,
                    :environment=>"test"
      end
    end
    
    def stop!
      server_thread.exit
    end
    
    def running?
      uri = URI.parse("http://localhost:#{port}/")
      req = Net::HTTP::Get.new(uri.path)
      
      begin
        resp = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(req)
        end
        return true
      rescue Exception => e
        # Connection refused means the daemon isn't running
        return false
      end
    end
    
    def load_fixtures
      require 'yaml'
      Dir.chdir(core_directory) do
        out = `rake videojuicer:sdk:setup`
        out = out.match(/!!!([^!]+)!!!/m)
        self.fixtures = YAML.load(out[1])
      end
    end
    
    def port
      5555
    end
    
  end
end


namespace :videojuicer do  
  namespace :core do
    
    task :setup do
      Rake::Task['videojuicer:core:load_fixtures'].invoke
      Rake::Task['videojuicer:core:start'].invoke
    end
    
    task :cleanup do
      #Rake::Task['videojuicer:core:stop'].invoke
    end
    
    task :load_fixtures do
      SDKTestHarness.load_fixtures
      puts "Loading fixtures from vj-core..."
      puts SDKTestHarness.fixtures.inspect
    end
    
    task :start do
      if SDKTestHarness.running?
        puts "The SDK Test harness is already running on port #{SDKTestHarness.port}"
      else
        SDKTestHarness.start!      
        puts "Waiting for test harness to launch and open the port."
        until SDKTestHarness.running? do
          print "."
          sleep 1
        end
      end
    end
    
    task :status do
      puts( if SDKTestHarness.running?
              "The test harness is RUNNING on port #{SDKTestHarness.port}"
            else
              "The test harness is NOT running on port #{SDKTestHarness.port}"
            end
          )
    end
    
    task :stop do
      if SDKTestHarness.running?
        SDKTestHarness.stop!
        puts "Waiting for exit"
        while SDKTestHarness.running? do
          print "."
          sleep 1
        end
      else
        puts "The test harness was not running and therefore could not be stopped. We advise that you do not attempt to confuse us with such philosophical quandries again."
      end
    end
    
  end
end

