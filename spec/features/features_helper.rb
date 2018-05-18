require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include Feature::Signing, type: :feature
  config.include Feature::Answer, type: :feature
  config.include Feature::Question, type: :feature
  config.include Feature::Attachement, type: :feature
  config.include Feature::Vote, type: :feature
  config.include Feature::Comment, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Capybara.server = :puma
