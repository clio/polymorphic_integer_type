module ActiveRecord
  module Associations
    class BelongsToPolymorphicAssociation < BelongsToAssociation
      private def replace_keys(record)
        super
        unless record.nil?
          owner[reflection.foreign_type] = record.class.base_class
        end
      end
    end
  end
end
