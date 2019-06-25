module PolymorphicIntegerType
  module PolymorphicArrayValueExtension
    def type_to_ids_mapping
      super.tap do |result|
        association = @associated_table.send(:association)
        klass = association.active_record
        name = association.name

        if klass.respond_to?("#{name}_type_mapping")
          result.transform_keys! do |key|
            klass.send("#{name}_type_mapping").key(key)
          end
        end
        result
      end
    end
  end
end

ActiveRecord::PredicateBuilder::PolymorphicArrayValue.prepend(PolymorphicIntegerType::PolymorphicArrayValueExtension)
