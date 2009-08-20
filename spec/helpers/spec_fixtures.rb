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
  
  class Campaign
    include FixtureHelper
    set_attribute_proc {{
      :name => /\w+/.gen
    }}
  end
  
  class Campaign::CampaignPolicy
    include FixtureHelper
    set_attribute_proc {{
	    :campaign_id => Campaign.gen.id,
	    :presentation_id => (Presentation.first.id rescue Presentation.gen.id)
    }}
  end
  
  class Criterion::DateRange
    include FixtureHelper
    set_attribute_proc {{
      :until => DateTime.send(:today) + 1,
      :after => DateTime.send(:today) - 1
    }}
  end
  
  class Criterion::Geolocation
    include FixtureHelper
    set_attribute_proc {{
      :city => "Columbus", 
      :region => "OH",
      :country => "United States"
    }}
  end
  
  class Criterion::Request
    include FixtureHelper
    set_attribute_proc {{
      :referrer => "http://www.google.com"
    }}
  end
  
  class Criterion::Time
    include FixtureHelper
    set_attribute_proc {{
      :after => (Time.now - 3600).strftime("%H%M"),
      :until => (Time.now + 3600).strftime("%H%M")
    }}
  end
  
  class Criterion::WeekDay
    include FixtureHelper
    set_attribute_proc {{
      :monday => true
    }}
  end
  
  class Promo::Image
    include FixtureHelper
    set_attribute_proc {{
      :role => "Thumbnail",
      :href => "http://www.videojuicer.com",
      :asset_id => 1
    }}
  end
  
  class Promo::Audio
    include FixtureHelper
    set_attribute_proc {{
      :role => "Voice Over",
      :href => "http://www.videojuicer.com",
      :asset_id => 1
    }}
  end
  
  class Promo::Video
    include FixtureHelper
    set_attribute_proc {{
      :role => "preroll",
      :href => "http://www.videojuicer.com",
      :asset_id => 1
    }}
  end
  
  class Promo::Text
    include FixtureHelper
    set_attribute_proc {{
      :role => "Description",
      :href => "http://www.videojuicer.com",
      :asset_id => 1
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
    
end