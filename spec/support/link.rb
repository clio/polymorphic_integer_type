class Link < ActiveRecord::Base

  include PolymorphicIntegerType

  SOURCE_MAPPING = {0 => "Person", 1 => "Animal"}
  TARGET_MAPPING = {0 => "Food", 1 => "Drink"}

  belongs_to :source, :polymorphic => true, :mapping => SOURCE_MAPPING
  belongs_to :target, :polymorphic => true, :mapping => TARGET_MAPPING

end
