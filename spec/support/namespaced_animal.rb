module Namespaced
    class Animal < ActiveRecord::Base

    self.store_full_sti_class = false
    self.table_name = "animals"

    def self.polymorphic_name
      "Animal"
    end
  end
end
