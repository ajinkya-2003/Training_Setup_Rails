# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'
require 'faker'

# Uncomment this line if you have support files (optional)
# Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Include FactoryBot methods like `create`, `build` directly in specs
  config.include FactoryBot::Syntax::Methods

  # Fixtures path
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Automatically infer spec type from file location
  config.infer_spec_type_from_file_location!

  # Filter out Rails gems from backtrace
  config.filter_rails_from_backtrace!
  # You can also filter other gems like:
  # config.filter_gems_from_backtrace("gem name")
end
