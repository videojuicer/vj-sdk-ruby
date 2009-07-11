=begin

  Prepares the vj-core development environment. Runs automatically before spec.

=end

require 'net/http'
require 'lib/sdk_connection_harness'

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
      SDKConnectionHarness.load_fixtures
      puts "Writing to tempfile..."
      SDKConnectionHarness.write_fixtures
    end
    
    task :start do
      if SDKConnectionHarness.running?
        puts "The SDK Test harness is already running on port #{SDKConnectionHarness.port}. Attempting to stop."
        SDKConnectionHarness.stop!
        until !SDKConnectionHarness.running? do
          print "+"
          sleep 1
        end
      else
        SDKConnectionHarness.start!      
        puts "Waiting for test harness to launch and open the port."
        until SDKConnectionHarness.running? do
          print "+"
          sleep 1
        end
      end
    end
    
    task :status do
      puts( if SDKConnectionHarness.running?
              "The test harness is RUNNING on port #{SDKConnectionHarness.port}"
            else
              "The test harness is NOT running on port #{SDKConnectionHarness.port}"
            end
          )
    end
    
    task :stop do
      if SDKConnectionHarness.running?
        SDKConnectionHarness.stop!
        puts "Waiting for exit"
        while SDKConnectionHarness.running? do
          print "."
          sleep 1
        end
      else
        puts "The test harness was not running and therefore could not be stopped. We advise that you do not attempt to confuse us with such philosophical quandries again."
      end
    end
    
  end
end

