module PolymorphicIntegerType
  module PredicateBuilderExtension
    def expand(klass, table, column, value)
      queries = []

      # Find the foreign key when using queries such as:
      # Post.where(author: author)
      #
      # For polymorphic relationships, find the foreign key and type:
      # PriceEstimate.where(estimate_of: treasure)
      if klass && reflection = klass._reflect_on_association(column)
        base_class = polymorphic_base_class_from_value(value)

        if reflection.polymorphic? && base_class
          if klass.respond_to?("#{column}_type_mapping")
            queries << build(table[reflection.foreign_type], klass.send("#{column}_type_mapping").key(base_class.to_s))
          else
            queries << build(table[reflection.foreign_type], base_class)
          end
        end

        column = reflection.foreign_key

        if base_class
          primary_key = reflection.association_primary_key(base_class)
          value = convert_value_to_association_ids(value, primary_key)
        end
      end

      queries << build(table[column], value)
      queries
    end
  end
end

ActiveRecord::PredicateBuilder.singleton_class.prepend(PolymorphicIntegerType::PredicateBuilderExtension)
