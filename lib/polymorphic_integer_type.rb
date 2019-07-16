require "polymorphic_integer_type/version"
require "polymorphic_integer_type/extensions"
require "polymorphic_integer_type/mapping"
if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new("5")
  require "polymorphic_integer_type/predicate_builder_extension"
else
  require "polymorphic_integer_type/polymorphic_array_value_extension"
end

module PolymorphicIntegerType; end
