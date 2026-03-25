# lex-postgres: PostgreSQL Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to PostgreSQL databases via the `pg` gem. Provides runners for arbitrary query execution and table introspection.

**GitHub**: https://github.com/LegionIO/lex-postgres
**License**: MIT
**Version**: 0.1.0

## Architecture

```
Legion::Extensions::Postgres
├── Runners/
│   ├── Queries  # execute, execute_params
│   └── Tables   # list_tables, describe_table, table_size
├── Helpers/
│   └── Client   # PG::Connection factory (host, port, dbname, user, password)
└── Client       # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/postgres.rb` | Entry point, extension registration |
| `lib/legion/extensions/postgres/runners/queries.rb` | SQL execution runners (plain and parameterized) |
| `lib/legion/extensions/postgres/runners/tables.rb` | Table introspection runners |
| `lib/legion/extensions/postgres/helpers/client.rb` | PG::Connection factory |
| `lib/legion/extensions/postgres/client.rb` | Standalone Client class |

## Connection Defaults

| Option | Default |
|--------|---------|
| `host` | `127.0.0.1` |
| `port` | `5432` |
| `dbname` | `postgres` |
| `user` | `postgres` |
| `password` | `nil` |

## Dependencies

| Gem | Purpose |
|-----|---------|
| `pg` (~> 1.5) | PostgreSQL Ruby adapter (requires libpq on system) |

## Development

25 specs total.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
