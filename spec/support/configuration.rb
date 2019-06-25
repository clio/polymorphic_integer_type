PolymorphicIntegerType::Mapping.configuration do |config|
  config.add :source, {1 => "Person", 2 => "Animal"}
  config.add :target, {1 => "Food", 2 => "Drink"}
end
