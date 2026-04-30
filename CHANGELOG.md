# Changelog

## v3.5.0 (2026-04-30)

### Added

- Add Rails 8.1 compatibility. Rails 8.1 changed `PredicateBuilder::PolymorphicArrayValue#initialize` from `(associated_table, values)` to `(reflection, values)`, dropping the `@associated_table` ivar. `type_to_ids_mapping` now reads `@reflection` when available and falls back to `@associated_table.send(:reflection)` for older Rails versions.

## v3.2.1 (2023-12-14)

### Fixed

- Not proper assigning polymorphic value with `has_many` and `has_one` reflection.

### Added

- Added .idea/ folder to .gitignore

## v3.2.2 (2023-12-21)

### Fixed

- Fixed polymorphic_foreign_association_extension.rb to be compatible with other reflection than `has_many` and `has_one`.

## v3.3.0 (2024-10-29)

### Changed

- Upgrade rails support version to be compatible with 7.2

### Removed

- Remove unsupported rails versions(5.0, 5.2, 6.0) and ruby version(2.7)

## v3.4.0 (2024-XX-XX)

### Added

- Add Rails 8.0 compatibility (requires Ruby 3.2+)

### Removed 
- Remove unsupported rails versions 6.x