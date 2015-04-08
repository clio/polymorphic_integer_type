module PolymorphicIntegerType

  module Extensions
    module ClassMethods

      def belongs_to(name, scope = nil, options = {})
        options = scope if scope.kind_of? Hash
        integer_type = options.delete :integer_type
        super
        if options[:polymorphic] && integer_type
          mapping = PolymorphicIntegerType::Mapping[name]
          foreign_type = reflections[name.to_s].foreign_type
          self._polymorphic_foreign_types << foreign_type

          define_method foreign_type do
            t = super()
            mapping[t]
          end

          define_method "#{foreign_type}=" do |klass|
            enum = mapping.key(klass.to_s)
            enum ||= mapping.key(klass.base_class.to_s) if klass.kind_of?(Class) && klass <= ActiveRecord::Base
            enum ||= klass if klass != NilClass
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

      def remove_type_and_establish_mapping(name, options, scope)
        integer_type = options.delete :integer_type
        if options[:as] && integer_type
          poly_type = options.delete(:as)
          mapping = PolymorphicIntegerType::Mapping[poly_type]
          klass_mapping = (mapping||{}).key self.sti_name
          raise "Polymorphic Class Mapping is missing for #{poly_type}" unless klass_mapping

          class_variable_set("@@poly_type_#{name}", klass_mapping.to_i)

          options[:foreign_key] ||= "#{poly_type}_id"
          foreign_type = options.delete(:foreign_type) || "#{poly_type}_type"
          class_variable_set("@@foreign_type_#{name}", foreign_type)

          options[:scope] ||= -> {
            condition = where(foreign_type => klass_mapping.to_i)
            condition = instance_exec(&scope).merge(condition) if scope.is_a?(Proc)
            condition
          }
        else
          options[:scope] ||= scope
        end
      end

      def has_many(name, scope = nil, options = {}, &extension)
        if scope.kind_of? Hash
          options = scope
          scope = nil
        end

        remove_type_and_establish_mapping(name, options, scope)
        prev_callback = options.delete(:before_add)
        new_callbacks = ["add_set_type_#{name}".to_sym]
        new_callbacks << prev_callback if prev_callback
        options = options.merge(:before_add => new_callbacks)
        super(name, options.delete(:scope), options, &extension)

        define_method "add_set_type_#{name}" do |record|
          record.send("#{self.class.class_variable_get("@@foreign_type_#{name}")}=", self.class.class_variable_get("@@poly_type_#{name}"))
        end

      end

      def has_one(name, scope = nil, options = {})
        if scope.kind_of? Hash
          options = scope
          scope = nil
        end

        remove_type_and_establish_mapping(name, options, scope)
        super(name, options.delete(:scope), options)
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
