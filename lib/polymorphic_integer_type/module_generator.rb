module PolymorphicIntegerType
  class ModuleGenerator
    def self.generate_and_include(klass,foreign_type, name)
      foreign_type_extension = Module.new do
        define_method foreign_type do
          t = super()
          self.class.send("#{foreign_type}_mapping")[t]
        end

        define_method "#{foreign_type}=" do |klass|
          mapping = self.class.send("#{foreign_type}_mapping")
          enum = mapping.key(klass.to_s)
          if klass.kind_of?(Class) && klass <= ActiveRecord::Base
            enum ||= mapping.key(klass.polymorphic_name) if klass.respond_to?(:polymorphic_name)
            enum ||= mapping.key(klass.sti_name)
            enum ||= mapping.key(klass.base_class.to_s)
            enum ||= mapping.key(klass.base_class.sti_name)
          end
          enum ||= klass if klass != NilClass
          super(enum)
        end

        define_method "#{name}=" do |record|
          super(record)
          send("#{foreign_type}=", record.class)
          association(name).loaded!
        end
      end

      klass.include(foreign_type_extension)
    end
  end
end

