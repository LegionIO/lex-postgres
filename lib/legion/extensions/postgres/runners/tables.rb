# frozen_string_literal: true

require 'legion/extensions/postgres/helpers/client'

module Legion
  module Extensions
    module Postgres
      module Runners
        module Tables
          def list_tables(schema: 'public', **)
            sql = 'SELECT table_name FROM information_schema.tables WHERE table_schema = $1 ORDER BY table_name'
            result = connection(**).exec_params(sql, [schema])
            { result: result.map { |row| row['table_name'] } }
          end

          def describe_table(table:, schema: 'public', **)
            sql = <<~SQL
              SELECT column_name, data_type, character_maximum_length, is_nullable, column_default
              FROM information_schema.columns
              WHERE table_schema = $1 AND table_name = $2
              ORDER BY ordinal_position
            SQL
            result = connection(**).exec_params(sql, [schema, table])
            { result: result.map { |row| row.transform_keys(&:to_sym) } }
          end

          def table_size(table:, **)
            sql = 'SELECT pg_total_relation_size($1) AS size'
            result = connection(**).exec_params(sql, [table])
            { result: result.first['size'].to_i }
          end

          extend Legion::Extensions::Postgres::Helpers::Client
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
