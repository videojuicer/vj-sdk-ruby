module Videojuicer
  module Criterion
    class Base
      
      def self.inherited(base)
        base.send(:include, Videojuicer::Resource)
        base.send(:extend, Videojuicer::Criterion::Base::ClassMethods)
        base.send(:include, Videojuicer::Criterion::Base::InstanceMethods)
      end
      
      module ClassMethods
        def singular_name
          "criterion"
        end
        
        def base_path(options={})
          "/criteria/#{self.to_s.split("::").last.snake_case}"
        end
        
        def get(*args); raise NoMethodError; end
        def all(*args); raise NoMethodError; end
        def first(*args); raise NoMethodError; end
      end
      
      module InstanceMethods
        def save(*args); raise NoMethodError; end
        def destroy(*args); raise NoMethodError; end
      end
            
    end
  end
end