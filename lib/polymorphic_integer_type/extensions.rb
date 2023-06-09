module PolymorphicIntegerType

  module Extensions
    module ClassMethods

      def belongs_to(name, scope = nil, **options)
        options = scope if scope.kind_of? Hash
        integer_type = options.delete :integer_type
        super
        if options[:polymorphic] && (integer_type || options[:polymorphic].is_a?(Hash))
          mapping =
            case integer_type
            when true then PolymorphicIntegerType::Mapping[name]
            when nil then options[:polymorphic]
            else
              raise ArgumentError, "Unknown integer_type value: #{integer_type.inspect}"
            end.dup

          foreign_type = reflections[name.to_s].foreign_type
          _polymorphic_foreign_types << foreign_type

          # Required way to dynamically define a class method on the model
          define_singleton_method("#{foreign_type}_mapping") do
            mapping
          end

          ModuleGenerator.generate_and_include(self, foreign_type, name)

          validate do
            t = send(foreign_type)
            unless t.nil? || mapping.values.include?(t)
              errors.add(foreign_type, "is not included in the mapping")
            end
          end
        end
      end

      def remove_type_and_establish_mapping(name, options, scope)
        integer_type = options.delete :integer_type
        polymorphic_type_mapping = retrieve_polymorphic_type_mapping(
          polymorphic_type: options[:as],
          class_name: options[:class_name] || name.to_s.classify
        )

        if options[:as] && (polymorphic_type_mapping || integer_type)
          poly_type = options.delete(:as)
          polymorphic_type_mapping ||= PolymorphicIntegerType::Mapping[poly_type]
          if polymorphic_type_mapping.nil?
            raise "Polymorphic type mapping missing for #{poly_type.inspect}"
          end

          klass_mapping = polymorphic_type_mapping.key(polymorphic_name) if respond_to?(:polymorphic_name)
          klass_mapping ||= polymorphic_type_mapping.key(sti_name)

          if klass_mapping.nil?
            raise "Class not found for #{inspect} in polymorphic type mapping: #{polymorphic_type_mapping}"
          end

          options[:foreign_key] ||= "#{poly_type}_id"
          foreign_type = options.delete(:foreign_type) || "#{poly_type}_type"

          options[:scope] ||= -> {
            condition = where(foreign_type => klass_mapping.to_i)
            condition = instance_exec(&scope).merge(condition) if scope.is_a?(Proc)
            condition
          }
        else
          options[:scope] ||= scope
        end
      end

      def retrieve_polymorphic_type_mapping(polymorphic_type:, class_name:)
        return if polymorphic_type.nil?

        belongs_to_class = compute_type(class_name)
        method_name = "#{polymorphic_type}_type_mapping"

        if belongs_to_class && belongs_to_class.respond_to?(method_name)
          belongs_to_class.public_send(method_name)
        end
      end

      def has_many(name, scope = nil, **options, &extension)
        if scope.kind_of? Hash
          options = scope
          scope = nil
        end

        remove_type_and_establish_mapping(name, options, scope)
        super(name, options.delete(:scope), **options, &extension)
      end

      def has_one(name, scope = nil, **options)
        if scope.kind_of? Hash
          options = scope
          scope = nil
        end

        remove_type_and_establish_mapping(name, options, scope)
        super(name, options.delete(:scope), **options)
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
