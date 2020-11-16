PolymorphicIntegerType::Mapping.configuration do |config|
  config.add :source, {1 => "Person", 2 => "Animal", 3 => "Plant"}
  config.add :target, {1 => "Food", 2 => "Drink", 3 => "Activity"}
end
