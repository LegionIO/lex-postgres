# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/queries'
require_relative 'runners/tables'

module Legion
  module Extensions
    module Postgres
      class Client
        include Runners::Queries
        include Runners::Tables

        attr_reader :opts

        def initialize(**opts)
          @opts = Helpers::Client::DEFAULTS.merge(opts)
        end

        def connection(**override)
          Helpers::Client.connection(**@opts, **override)
        end
      end
    end
  end
end
