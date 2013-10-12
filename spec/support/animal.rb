class Animal < ActiveRecord::Base

  belongs_to :owner, :class_name => "Person"
  has_many :source_links, :as => :source, :class_name => "Link"



end
