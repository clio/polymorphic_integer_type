class Drink < ActiveRecord::Base

  include PolymorphicIntegerType::Extensions

  has_many :target_links, :as => :target, :integer_type => true, :class_name => "Link"



end
