module Namespaced
  class Activity < ActiveRecord::Base
    include PolymorphicIntegerType::Extensions

    self.store_full_sti_class = false
    self.table_name = "activities"

    has_many :target_links, as: :target, inverse_of: :target, integer_type: true, class_name: "Link"
  end
end

