class Animal < ActiveRecord::Base

  include PolymorphicIntegerType::Extensions

  belongs_to :owner, :class_name => "Person"
  has_many :source_links, :as => :source, :integer_type => true, :class_name => "Link"



end
