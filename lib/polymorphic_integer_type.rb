require "polymorphic_integer_type/version"

module PolymorphicIntegerType
  
  module ClassMethods
    
    def belongs_to(name, options = {})
      super
      if options[:polymorphic]
        foreign_type = reflections[:poly].foreign_type

        define_method :[] do |value|
          if value == foreign_type
            send(reflections[:poly].foreign_type)
          else
            super
          end
        end
        
        define_method foreign_type do
          t = super
          options[:mapping][t]
        end

      end
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end  


end
