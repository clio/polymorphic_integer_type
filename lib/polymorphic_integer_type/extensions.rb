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
          attribute foreign_type, TypeCaster.new(mapping: mapping, klass: self)

          singleton_class.__send__(:define_method, "#{foreign_type}_mapping") do
            mapping
          end


          validate do
            t = send(foreign_type)
            unless t.nil? || mapping.values.include?(t)
              errors.add(foreign_type, "is not included in the mapping")
            end
          end
        end
      end

      def has_many(name, scope = nil, **options, &extension)
        if scope.kind_of? Hash
          scope.delete :integer_type
        else
          options.delete :integer_type
        end
        super
      end

      def has_one(name, scope = nil, **options)
        if scope.kind_of? Hash
          scope.delete :integer_type
        else
          options.delete :integer_type
        end
        super
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

  end

end
