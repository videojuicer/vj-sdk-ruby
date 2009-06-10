=begin

  Prepares the vj-core development environment. Runs automatically before spec.

=end

require 'net/http'

class ::SDKTestHarness
  class << self

    attr_accessor :server_pid
    attr_accessor :fixtures

    def core_directory
      File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "vj-core"))
    end
    
    def start!
      stop! if running?
      puts "Starting vj-core from #{core_directory}\n"
      Thread.new do
        cur_dir = Dir.pwd
        Dir.chdir(core_directory) do
          `merb -d -p #{port} -e test --log .log/sdk-development.log`
        end
        Dir.chdir(cur_dir)
      end
    end
    
    def stop!
      Thread.new do
        `killall -9 "merb : worker (port #{port})"`
      end
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
      Dir.chdir(core_directory) do
        out = `rake videojuicer:sdk:setup MERB_ENV=test`
        out = out.match(/!!!([^!]+)!!!/m)
        self.fixtures = out[1]
      end
    end
    
    def write_fixtures
      f = File.open(File.join(File.dirname(__FILE__), "..", "core-fixtures.yml"), "w+")
      f.rewind
      f.write(self.fixtures)
      f.close
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
      Rake::Task['videojuicer:core:stop'].invoke
    end
    
    task :load_fixtures do
      puts "Loading fixtures from vj-core..."
      SDKTestHarness.load_fixtures
      puts "Writing to tempfile..."
      SDKTestHarness.write_fixtures
    end
    
    task :start do
      if SDKTestHarness.running?
        puts "The SDK Test harness is already running on port #{SDKTestHarness.port}. Attempting to stop."
        SDKTestHarness.stop!
        until !SDKTestHarness.running? do
          print "+"
          sleep 1
        end
      else
        SDKTestHarness.start!      
        puts "Waiting for test harness to launch and open the port."
        until SDKTestHarness.running? do
          print "+"
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

