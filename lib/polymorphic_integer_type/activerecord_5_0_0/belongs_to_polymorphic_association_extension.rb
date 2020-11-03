module ActiveRecord
  module Associations
    class BelongsToPolymorphicAssociation < BelongsToAssociation
      private def replace_keys(record)
        super
        if owner.respond_to?(:_polymorphic_foreign_types) && owner._polymorphic_foreign_types.include?(reflection.foreign_type)
          if record
            owner[reflection.foreign_type] = record.class
          else
            owner[reflection.foreign_type] = nil
          end
        elsif record.respond_to?(:polymorphic_name)
          owner[reflection.foreign_type] = record.class.polymorphic_name
        else
          owner[reflection.foreign_type] = record.class.base_class.name
        end
      end
    end
  end
end
