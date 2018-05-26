require 'rails_helper'
require 'rspec/json_expectations'

RSpec.configure do |config|
  config.include JsonResponsedMacros, type: :controller
end
