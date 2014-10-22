class Rails4Target < ActiveRecord::Base

  include PolymorphicIntegerType::Extensions

  belongs_to :scope_tester, polymorphic: true, integer_type: true
  
end
