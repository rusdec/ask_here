require 'rails_helper'
require "json_matchers/rspec"
require 'rspec/json_expectations'

RSpec.configure do |config|
  config.include JsonResponsedMacros, type: :controller
end

JsonMatchers.schema_root = "spec/support/controllers/schemas"
