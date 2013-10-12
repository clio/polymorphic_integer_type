class Animal < ActiveRecord::Base

  belongs_to :owner, :class_name => "Person"
  has_many :source_links, :as => :source, :class_name => "Link"

  has_many :food_and_drinks, :through => :source_links, :source => :source


end
