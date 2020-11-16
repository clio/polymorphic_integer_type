module Namespaced
  class Plant < ActiveRecord::Base
    include PolymorphicIntegerType::Extensions

    self.store_full_sti_class = false
    self.table_name = "plants"

    belongs_to :owner, class_name: "Person"
    has_many :source_links, as: :source, integer_type: true, class_name: "Link"
  end
end
