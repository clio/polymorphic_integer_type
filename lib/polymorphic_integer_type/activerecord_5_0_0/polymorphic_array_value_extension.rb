module PolymorphicIntegerType
  module PolymorphicArrayValueExtension

    # original method:
    # def type_to_ids_mapping
    #   default_hash = Hash.new { |hsh, key| hsh[key] = [] }
    #   result = values.each_with_object(default_hash) do |value, hash|
    #     hash[klass(value).polymorphic_name] << convert_to_id(value)
    #   end
    # end

    def type_to_ids_mapping
      association = @associated_table.send(:association)
      name = association.name
      default_hash = Hash.new { |hsh, key| hsh[key] = [] }

      values.each_with_object(default_hash) do |value, hash|
        klass = klass(value)
        if association.active_record.respond_to?("#{name}_type_mapping")
          mapping = association.active_record.send("#{name}_type_mapping")
          key ||= mapping.key(klass.polymorphic_name)
          key ||= mapping.key(klass.sti_name)
          key ||= mapping.key(klass.base_class.to_s)
          key ||= mapping.key(klass.base_class.sti_name)

          hash[key] << convert_to_id(value)
        else
          hash[klass.polymorphic_name] << convert_to_id(value)
        end
      end
    end
  end
end

ActiveRecord::PredicateBuilder::PolymorphicArrayValue.prepend(PolymorphicIntegerType::PolymorphicArrayValueExtension)
