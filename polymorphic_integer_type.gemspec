# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polymorphic_integer_type/version'

Gem::Specification.new do |spec|
  spec.name          = "polymorphic_integer_type"
  spec.version       = PolymorphicIntegerType::VERSION
  spec.authors       = ["Kyle d'Oliveira"]
  spec.email         = ["kyle@goclio.com"]
  spec.description   = %q{Allows the *_type field in the DB to be an integer rather than a string}
  spec.summary       = %q{Use integers rather than strings for the _type field}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -- . ':!.github/'`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry-byebug"
end
