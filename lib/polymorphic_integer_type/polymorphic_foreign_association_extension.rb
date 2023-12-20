module PolymorphicIntegerType
  module PolymorphicForeignAssociationExtension

    def set_owner_attributes(record)
      super
      if reflection.try(:foreign_integer_type) && reflection.try(:integer_type)
        record._write_attribute(reflection.foreign_integer_type, reflection.integer_type)
      end
    end
  end
end
