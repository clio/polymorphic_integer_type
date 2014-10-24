PolymorphicIntegerType::Mapping.configuration do |config|

  config.add :source, {0 => "Person", 1 => "Animal"}
  config.add :target, {0 => "Food", 1 => "Drink"}
  config.add :scope_tester, {1 => "Rails4Scope"}

end
