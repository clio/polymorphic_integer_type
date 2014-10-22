class Rails4Scope < ActiveRecord::Base

  include PolymorphicIntegerType::Extensions

  has_many :rails4_targets, -> {where(extra: true)}, as: :scope_tester, integer_type: true
  
end
