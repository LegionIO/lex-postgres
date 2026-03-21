# frozen_string_literal: true

require 'pg'

module Legion
  module Extensions
    module Postgres
      module Helpers
        module Client
          DEFAULTS = { host: '127.0.0.1', port: 5432, dbname: 'postgres', user: 'postgres' }.freeze

          def self.connection(**opts)
            merged = DEFAULTS.merge(opts)
            connect_hash = merged.slice(:host, :port, :dbname, :user)
            connect_hash[:password] = merged[:password] if merged[:password]
            ::PG::Connection.new(**connect_hash)
          end
        end
      end
    end
  end
end
