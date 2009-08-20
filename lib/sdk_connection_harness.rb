require 'mash'
require 'yaml'
class SDKConnectionHarness
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
          `./bin/merb -d -a #{app_server} -p #{port} -e test --log ./log/sdk-development.log`
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
        out = `./bin/rake videojuicer:sdk:setup MERB_ENV=test`
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
    
    def app_server
      `which thin`.empty? ? "mongrel" : "thin"
    end
    
    def port
      6666
    end
    
    def connect(overrides={})
      fixtures = Mash.new(YAML.load(load_fixtures)).merge(overrides)
      configure_test_settings(overrides)
      Videojuicer.enter_scope :seed_name => fixtures.seed.name, 
                              :consumer_key=>fixtures["write-master"].consumer.consumer_key,
                              :consumer_secret=>fixtures["write-master"].consumer.consumer_secret,
                              :token=>fixtures["write-master"].authorized_token.oauth_token,
                              :token_secret=>fixtures["write-master"].authorized_token.oauth_token_secret
    end
    
    def configure_test_settings(overrides={})
      Videojuicer.configure!({
        :consumer_key     => nil,
        :consumer_secret  => nil,
        :api_version      => 1,
        :protocol         => "http",
        :host             => "localhost",
        :port             => port
      }.merge(overrides))
    end
    
  end
end