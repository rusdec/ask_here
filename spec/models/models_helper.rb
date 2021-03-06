require 'rails_helper'

Dir[Rails.root.join('spec/models/concerns/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include OmniauthMacros, type: :model
end
