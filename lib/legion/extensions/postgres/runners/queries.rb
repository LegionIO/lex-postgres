# frozen_string_literal: true

require 'legion/extensions/postgres/helpers/client'

module Legion
  module Extensions
    module Postgres
      module Runners
        module Queries
          def execute(sql:, **)
            result = connection(**).exec(sql)
            { result: result.map { |row| row.transform_keys(&:to_sym) } }
          end

          def execute_params(sql:, params: [], **)
            result = connection(**).exec_params(sql, params)
            { result: result.map { |row| row.transform_keys(&:to_sym) } }
          end

          extend Legion::Extensions::Postgres::Helpers::Client
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
        end
      end
    end
  end
end
