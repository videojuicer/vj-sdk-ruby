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
      def gen_attributes
        attribute_proc.call
      end
      def attribute_proc
        @attribute_proc || Proc.new {{}}
      end
      def attribute_proc=(arg); @attribute_proc=arg; end
    end
    
    module InstanceMethods
      
    end
  end
  
  class User
    include FixtureHelper
    self.attribute_proc = Proc.new {{
     :foo=>"bar" 
    }}
  end
  
  class Presentation    
    include FixtureHelper
  end
  
  class Campaign
    include FixtureHelper
  end
  
  class CampaignPolicy
    include FixtureHelper
  end
  
end