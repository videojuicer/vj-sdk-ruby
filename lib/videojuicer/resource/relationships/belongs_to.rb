module Videojuicer
  module Resource
    module Relationships
      module BelongsTo
   
        def self.included(base)
          base.extend(ClassMethods)
        end
        
        module ClassMethods
          
          def belongs_to(name, options={})
            options = {
              :class=>name.to_s.capitalize,
              :foreign_key=>"#{name}_id"
            }.merge(options)
            
            define_method name do
              id = self.send(options[:foreign_key])
              klass = (options[:class].is_a?(String))? Videojuicer.const_get(options[:class]) : options[:class]
              return nil unless id
              begin
                return klass.get(id)
              rescue Videojuicer::Exceptions::NoResource
                return nil
              end
            end
            
            define_method "#{name}=" do |arg|
              self.send("#{options[:foreign_key]}=", arg.id)
            end
          end
          
        end
        
      end
    end
  end
end