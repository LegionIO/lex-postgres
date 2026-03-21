# frozen_string_literal: true

require 'bundler/setup'

# Stub Legion::Extensions::Helpers::Lex before loading any runners.
# In production the full LegionIO framework provides this; in specs we
# replicate only the behaviour the runner files actually rely on.
module Legion
  module Extensions
    module Helpers
      module Lex
        def self.included(base)
          base.extend base if base.instance_of?(Module)
        end
      end
    end
  end
end

require 'legion/extensions/postgres'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
