ACTIVE_RECORD_VERSION = Gem::Version.new(ActiveRecord::VERSION::STRING)

require "polymorphic_integer_type/version"
require "polymorphic_integer_type/extensions"
require "polymorphic_integer_type/mapping"
require "polymorphic_integer_type/module_generator"
require "polymorphic_integer_type/belongs_to_polymorphic_association_extension"

if ACTIVE_RECORD_VERSION < Gem::Version.new("5")
  require "polymorphic_integer_type/activerecord_4/predicate_builder_extension"
else
  require "polymorphic_integer_type/activerecord_5_0_0/polymorphic_array_value_extension"
end

if ACTIVE_RECORD_VERSION >= Gem::Version.new("5.0") && ACTIVE_RECORD_VERSION < Gem::Version.new("5.2.0")
  require "polymorphic_integer_type/activerecord_5_0_0/association_query_handler_extension"
end

module PolymorphicIntegerType; end
