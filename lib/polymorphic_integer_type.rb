require "polymorphic_integer_type/version"

module PolymorphicIntegerType

  module ClassMethods

    def belongs_to(name, options = {})
      mapping = options.delete(:mapping)
      super
      if options[:polymorphic]
        foreign_type = reflections[name].foreign_type

        define_method foreign_type do
          t = super()
          mapping[t]
        end

        define_method "#{foreign_type}=" do |klass|
          enum = mapping.key(klass.to_s)
          super(enum)
        end

        define_method "#{name}=" do |record|
          super(record)
          send("#{foreign_type}=", record.class)
        end

      end
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def _polymorphic_foreign_types
    @_polymorphic_foreign_types ||= reflections.values.collect do
      |assoc| assoc.foreign_type if assoc.options[:polymorphic]
    end.compact
  end

  def [](value)
    if _polymorphic_foreign_types.include?(value)
      send(value)
    else
      super(value)
    end
  end

end
