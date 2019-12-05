module Namespaced
    class Animal < ActiveRecord::Base

    self.store_full_sti_class = false
    self.table_name = "animals"
  end
end