module ActiveRecord
  module Associations
    class BelongsToPolymorphicAssociation < BelongsToAssociation
      private

      def replace_keys(record, force: false)
        super
        owner[reflection.foreign_type] = record.class.base_class unless record.nil?
      end
    end
  end
end
