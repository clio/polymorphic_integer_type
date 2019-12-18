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

    def polymorphic_value_for(value)
      table = value.associated_table
      association = table.send(:association)
      klass = association.active_record
      name = association.name

      if klass.respond_to?("#{name}_type_mapping")
        klass.send("#{name}_type_mapping").key(value.base_class.sti_name)
      else
        value.base_class.name
      end
    end


  end
end

ActiveRecord::PredicateBuilder::AssociationQueryHandler.prepend(PolymorphicIntegerType::AssociationQueryHandlerExtension)
