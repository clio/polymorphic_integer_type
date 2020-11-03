ACTIVE_RECORD_VERSION = Gem::Version.new(ActiveRecord::VERSION::STRING)

require "polymorphic_integer_type/version"
require "polymorphic_integer_type/extensions"
require "polymorphic_integer_type/mapping"
require "polymorphic_integer_type/type_caster"

require "polymorphic_integer_type/activerecord_5_0_0/polymorphic_array_value_extension"
require "belongs_to_polymorphic_association_extension"

module PolymorphicIntegerType; end
