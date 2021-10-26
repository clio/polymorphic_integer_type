module ActiveRecord
  module Associations
    class BelongsToPolymorphicAssociation < BelongsToAssociation
      private

      if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new("6.1")
        def replace_keys(record)
          super
          owner[reflection.foreign_type] = record.class.base_class unless record.nil?
        end
      elsif
        def replace_keys(record, force: false)
          super
          owner[reflection.foreign_type] = record.class.base_class unless record.nil?
        end
      end
    end
  end
end
