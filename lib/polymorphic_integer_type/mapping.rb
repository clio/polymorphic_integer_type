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

  end

end
