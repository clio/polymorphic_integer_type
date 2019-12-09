class Link < ActiveRecord::Base
  include PolymorphicIntegerType::Extensions

  belongs_to :source, polymorphic: true, integer_type: true
  belongs_to :target, polymorphic: true, integer_type: true

  def source=(val)
    super(val)
  end

  def source_type=(val)
    super(val)
  end
end
