class Drink < ActiveRecord::Base

  has_many :target_links, :as => :target, :class_name => "Link"

  has_many :people_and_animals, :through => :target_links, :source => :target


end
