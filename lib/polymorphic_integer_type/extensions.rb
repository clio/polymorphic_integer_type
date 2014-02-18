module PolymorphicIntegerType

  module Extensions
    module ClassMethods

      def belongs_to(name, options = {})
        integer_type = options.delete :integer_type
        super
        if options[:polymorphic] && integer_type
          mapping = PolymorphicIntegerType::Mapping[name]
          foreign_type = reflections[name].foreign_type
          self._polymorphic_foreign_types << foreign_type

          define_method foreign_type do
            t = super()
            mapping[t]
          end

          define_method "#{foreign_type}=" do |klass|
            enum = mapping.key(klass.to_s) || klass
            super(enum)
          end

          define_method "#{name}=" do |record|
            super(record)
            send("#{foreign_type}=", record.class)
          end

          validate do
            t = send(foreign_type)
            unless t.nil? || mapping.values.include?(t)
              errors.add(foreign_type, "is not included in the mapping")
            end
          end
        end
      end

      def remove_type_and_establish_mapping(name, options)
        integer_type = options.delete :integer_type
        if options[:as] && integer_type
          poly_type = options.delete(:as)
          mapping = PolymorphicIntegerType::Mapping[poly_type]
          klass_mapping = (mapping||{}).key self.sti_name
          raise "Polymorphic Class Mapping is missing for #{poly_type}" unless klass_mapping

          options[:foreign_key] ||= "#{poly_type}_id"
          foreign_type = options.delete(:foreign_type) || "#{poly_type}_type"
          options[:lambda] ||= ->(n){where(foreign_type => klass_mapping.to_i)}
        end
      end

      def has_many(name, options = {}, &extension)
        remove_type_and_establish_mapping(name, options)
        super(name, options.delete(:lambda), &extension)
      end

      def has_one(name, options = {})
        remove_type_and_establish_mapping(name, options)
        super(name, options.delete(:lambda), options)
      end


    end

    def self.included(base)
      base.class_eval {
        cattr_accessor :_polymorphic_foreign_types
        self._polymorphic_foreign_types = []
      }
      base.extend(ClassMethods)
    end

    def _polymorphic_foreign_types
      self.class._polymorphic_foreign_types
    end

    def [](value)
      if _polymorphic_foreign_types.include?(value)
        send(value)
      else
        super(value)
      end
    end

    def []=(attr_name, value)
      if _polymorphic_foreign_types.include?(attr_name)
        send("#{attr_name}=", value)
      else
        super(attr_name, value)
      end
    end

  end

end
