# frozen_string_literal: true

require 'legion/extensions/postgres/version'
require 'legion/extensions/postgres/helpers/client'
require 'legion/extensions/postgres/runners/queries'
require 'legion/extensions/postgres/runners/tables'
require 'legion/extensions/postgres/client'

module Legion
  module Extensions
    module Postgres
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
