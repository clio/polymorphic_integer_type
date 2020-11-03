module ActiveRecord
  module Associations
    class BelongsToPolymorphicAssociation < BelongsToAssociation
      private def replace_keys(record)
        super
        if record
          owner[reflection.foreign_type] = record.class.base_class
        else
          owner[reflection.foreign_type] = nil
        end
      end
    end
  end
end
