module PolymorphicIntegerType
  module AssociationQueryHandlerExtension
    def call(attribute, value)
      queries = {}
      table = value.associated_table

      if value.base_class
        queries[table.association_foreign_type.to_s] = polymorphic_value_for(value)
      end

      queries[table.association_foreign_key.to_s] = value.ids
      predicate_builder.build_from_hash(queries)
    end

    protected

    def polymorphic_value_for(query_value)
      table = query_value.associated_table
      association = table.send(:association)
      klass = association.active_record
      name = association.name

      if klass.respond_to?("#{name}_type_mapping")
        type_mapping = klass.send("#{name}_type_mapping")

        type_mapping.key(query_value.value.class.sti_name) ||
          type_mapping.key(query_value.base_class.to_s) ||
          type_mapping.key(query_value.base_class.sti_name)
      else
        query_value.base_class.name
      end
    end


  end
end

ActiveRecord::PredicateBuilder::AssociationQueryHandler.prepend(PolymorphicIntegerType::AssociationQueryHandlerExtension)
