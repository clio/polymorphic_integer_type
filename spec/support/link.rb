class Link < ActiveRecord::Base
  EMPTY_COMMENT = 'no comment'
  include PolymorphicIntegerType::Extensions

  belongs_to :source, :polymorphic => true, :integer_type => true
  belongs_to :target, :polymorphic => true, :integer_type => true

end
