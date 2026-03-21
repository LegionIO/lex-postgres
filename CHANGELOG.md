# Changelog

## [0.1.0] - 2026-03-21

### Added
- Initial release
- `Helpers::Client` module with `.connection` method wrapping `PG::Connection`
- `Runners::Queries` with `execute` (arbitrary SQL) and `execute_params` (parameterized SQL with `$1`/`$2` placeholders)
- `Runners::Tables` with `list_tables`, `describe_table`, and `table_size` using `information_schema` and `pg_total_relation_size`
- Standalone `Client` class including all runner modules
- Full RSpec test suite (15 specs across 3 spec files)
