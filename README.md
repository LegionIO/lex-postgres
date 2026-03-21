# lex-postgres

A LegionIO extension (LEX) that connects LegionIO to PostgreSQL databases via the `pg` gem.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-postgres'
```

## Standalone Usage

```ruby
require 'lex-postgres'

client = Legion::Extensions::Postgres::Client.new(
  host:     'db.example.com',
  port:     5432,
  dbname:   'myapp',
  user:     'jane.doe',
  password: 'secret'
)

# Execute arbitrary SQL
client.execute(sql: 'SELECT version()')
# => { result: [{ version: "PostgreSQL 16.0 ..." }] }

# Parameterized query
client.execute_params(sql: 'SELECT * FROM users WHERE id = $1', params: [42])
# => { result: [{ id: "42", name: "Jane Doe", email: "jane.doe@example.com" }] }

# List tables in a schema
client.list_tables(schema: 'public')
# => { result: ["orders", "products", "users"] }

# Describe a table's columns
client.describe_table(table: 'users')
# => { result: [{ column_name: "id", data_type: "integer", ... }, ...] }

# Total on-disk size of a table (bytes)
client.table_size(table: 'orders')
# => { result: 8192 }
```

## Runner Methods

### Queries

| Method | Description |
|--------|-------------|
| `execute(sql:)` | Run arbitrary SQL, returns rows as array of symbol-keyed hashes |
| `execute_params(sql:, params: [])` | Parameterized query with `$1`, `$2` placeholders |

### Tables

| Method | Description |
|--------|-------------|
| `list_tables(schema: 'public')` | List table names in the given schema |
| `describe_table(table:, schema: 'public')` | Column definitions from `information_schema.columns` |
| `table_size(table:)` | Total relation size in bytes via `pg_total_relation_size` |

## Connection Defaults

| Option | Default |
|--------|---------|
| `host` | `127.0.0.1` |
| `port` | `5432` |
| `dbname` | `postgres` |
| `user` | `postgres` |
| `password` | `nil` (omitted if not set) |

## License

MIT
