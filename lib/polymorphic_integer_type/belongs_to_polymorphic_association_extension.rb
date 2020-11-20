module ActiveRecord
  module Associations
    class BelongsToPolymorphicAssociation < BelongsToAssociation
      private def replace_keys(record)
        super
        klass = record.nil? ? record.class : record.class.base_class

        owner[reflection.foreign_type] = klass
      end
    end
  end
end
