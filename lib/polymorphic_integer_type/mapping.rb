module PolymorphicIntegerType

  class Mapping
    @@mapping = {}

    def self.configuration
      yield(self)
    end

    def self.add(as, mapping)
      @@mapping[as] = mapping
    end

    def self.[](as)
      @@mapping[as] || {}
    end

    singleton_class.send(:alias_method, :[]=, :add)
  end
end
