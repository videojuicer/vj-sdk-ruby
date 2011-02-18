module Videojuicer
  module Resource
    module Relationships
      module Has
   
        def self.included(base)
          base.extend(ClassMethods)
          base.include(InstanceMethods)
        end
        
        module ClassMethods
          
          # Returns a :many quantifier for the ##has method.
          def n
            :many
          end
          
          def has(quantifier, name, options={})
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
        
        module InstanceMethods
          
          private
          def write_has_one_object(object)
          end
          
        end
        
      end
    end
  end
end