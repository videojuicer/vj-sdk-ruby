=begin rdoc
  SDK Fixtures
  
  Here is a fixture helper. It helps you generate good attributes for use in your
  test instances.
=end

module Videojuicer
  
  module FixtureHelper
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend, ClassMethods)
    end
    
    module ClassMethods
      def gen(fixture=:default, overrides={})
        fixture, overrides = :default, fixture if fixture.is_a?(Hash)
        create(gen_attributes(fixture).merge(overrides))
      end
      
      def gen_attributes(fixture=:default)
        attribute_proc(fixture).call
      end
      def blank_attributes(fixture=:default)
        gen_attributes(fixture).inject({}) do |memo, (key, value)|
          memo.update(key => " ")
        end
      end
      def attribute_proc(fixture=:default)
        @attribute_procs[fixture]
      end
      def set_attribute_proc(fixture=:default, &block)
        @attribute_procs ||= {}
        @attribute_procs[fixture] = block
      end
    end
    
    module InstanceMethods
      
    end
  end
  
  class User
    include FixtureHelper
    set_attribute_proc {{
      :login => /testuser(\d{1,5})/.gen,
      :name => /(\d{1,5}) Jones/.gen,
      :email => /test(\d{1,5}+)@test\.videojuicer\.com/.gen,
      :password => "#{p = rand(99999)}",
      :password_confirmation => p
    }}
  end
  
  class Presentation    
    include FixtureHelper
    set_attribute_proc {{
      :title=>/Presentation title (\d{1,5})/.gen,
      :abstract=>/Presentation abstract (\d{1,5})/.gen,
      :author=>"Bob Anon"
    }}
  end
  
  class Insert
    include FixtureHelper
    set_attribute_proc {{
      :campaign_id => (Campaign.first.id rescue Campaign.gen.id),
      :asset_type => "com.videojuicer.core.asset.Audio",
      :asset_id   => (Asset::Audio.first.id rescue Asset::Audio.gen.id)
    }}
  end
  
  class Campaign
    include FixtureHelper
    set_attribute_proc {{
      :name => /\w+/.gen,
      :target_type => "com.videojuicer.core.Presentation"
    }}
  end
  
  class Criterion::DateRange
    include FixtureHelper
    set_attribute_proc {{
      :campaign_id => 1,
      :until => DateTime.send(:today) + 1,
      :from => DateTime.send(:today) - 1
    }}
  end
  
  class Criterion::Geolocation
    include FixtureHelper
    set_attribute_proc {{
      :campaign_id => 1,
      :city => "Columbus", 
      :region => "OH",
      :country => "United States"
    }}
  end
  
  class Criterion::Request
    include FixtureHelper
    set_attribute_proc {{
      :campaign_id => 1,
      :referrer => "http://www.google.com",
      :exclude => false
    }}
  end
  
  class Criterion::Time
    include FixtureHelper
    set_attribute_proc {{
      :campaign_id => 1,
      :from => (Time.now - 3600).strftime("%H:%M"),
      :until => (Time.now + 3600).strftime("%H:%M")
    }}
  end
  
  class Criterion::WeekDay
    include FixtureHelper
    set_attribute_proc {{
      :campaign_id => 1,
      :monday => true,
      :exclude => false
    }}
  end
  
  class Asset::Audio
    include FixtureHelper
    set_attribute_proc {{
      :user_id        => rand(100) + 1,
      :licensed_at    => Time.now,
      :licensed_by    => "foo, bar",
      :licensed_under => "CC BY:NC:SA",
      :published_at   => Time.now,
      :file => File.open(File.join(File.dirname(__FILE__), "..", "files", "audio.mp3"))
    }}
  end
  
  class Asset::Image
    include FixtureHelper
    set_attribute_proc {{
      :user_id        => rand(100) + 1,
      :licensed_at    => Time.now,
      :licensed_by    => "foo, bar",
      :licensed_under => "CC BY:NC:SA",
      :published_at   => Time.now,
      :file => File.open(File.join(File.dirname(__FILE__), "..", "files", "image.jpg"))
    }}
  end
  
  class Asset::Flash
    include FixtureHelper
    set_attribute_proc {{
      :user_id        => rand(100) + 1,
      :licensed_at    => Time.now,
      :licensed_by    => "foo, bar",
      :licensed_under => "CC BY:NC:SA",
      :published_at   => Time.now,
      :file => File.open(File.join(File.dirname(__FILE__), "..", "files", "flash.swf"))
    }}
  end
  
  class Asset::Text
    include FixtureHelper
    set_attribute_proc {{
      :user_id        => rand(100) + 1,
      :licensed_at    => Time.now,
      :licensed_by    => "foo, bar",
      :licensed_under => "CC BY:NC:SA",
      :published_at   => Time.now,
      :file => File.open(File.join(File.dirname(__FILE__), "..", "files", "text.txt"))
    }}
  end
  
  class Asset::Document
    include FixtureHelper
    set_attribute_proc {{
      :user_id        => rand(100) + 1,
      :licensed_at    => Time.now,
      :licensed_by    => "foo, bar",
      :licensed_under => "CC BY:NC:SA",
      :published_at   => Time.now,
      :file => File.open(File.join(File.dirname(__FILE__), "..", "files", "document.js"))
    }}
  end
  
  
  class Asset::Video
    include FixtureHelper
    set_attribute_proc {{
      :user_id           => rand(100) + 1,
      :licensed_at       => Time.now,
      :licensed_by       => "foo, bar",
      :licensed_under    => "CC BY:NC:SA",
      :published_at      => Time.now,
      :file => File.open(File.join(File.dirname(__FILE__), "..", "files", "video.mov"))
    }}
  end
  
  class Preset
    include FixtureHelper
    set_attribute_proc {{
      :name         => /\w{10}/.gen,
      :derived_type => "Video",
      :file_format  => "mp4",
      :audio_format => "libfaac",
      :video_format => "mpeg4",
      :width        => 640,
      :height       => 480
    }}
  end
    
end