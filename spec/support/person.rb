class Person < ActiveRecord::Base

  include PolymorphicIntegerType::Extensions

  has_many :pets, :class_name => "Animal", :foreign_key => :owner_id
  has_many :source_links, :as => :source, :integer_type => true, :class_name => "Link"

  has_many :pet_source_links, :class_name => "Link", :through => :pets, :source => :source_links


end
