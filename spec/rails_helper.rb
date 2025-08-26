# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
if ENV["RAILS_ENV"] == "test"
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "config/initializers/sentry.rb"
    add_filter "config/initializers/flipper.rb"
    add_filter "config/routes.rb"
    add_filter "spec/factories/*"
    add_filter "spec/support/*"

    add_group "Policies", "app/policies"
    add_group "Presenters", "app/presenters"
    add_group "Serializers", "app/serializers"
    add_group "Services", "app/services"
    add_group "Validators", "app/validators"
    Dir["app/*"].each do |dir|
      add_group File.basename(dir).downcase, dir
    end
  end
end

require "spec_helper"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require_relative "support/factory_bot"
require_relative "support/chrome"
require "devise"
require_relative "support/controller_macros"
require "view_component/test_helpers"
require "capybara/rspec"

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include ViewComponent::TestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component

  config.after(:each, :snapshot, type: :component) do |example|
    class_name = example.metadata[:described_class].name.underscore
    test_name = example.metadata[:full_description].gsub(example.metadata[:described_class].name, "").tr(" ", "_")
    raise "component snapshot has no content" if rendered_component.blank?

    expect(rendered_component).to match_snapshot("#{class_name}/#{test_name}")
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = Rails.root.join("spec/fixtures")

  # config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  # ---------------------------------------------
  # add from here
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Devise::Test::ControllerHelpers, type: :controller

  config.include Warden::Test::Helpers

  ActiveStorage::Current.url_options = { host: "https://example.com" }

  # add until here
  # ---------------------------------------------

  config.before(:suite) do
    config.include Devise::Test::ControllerHelpers, type: :controller
    config.include FactoryBot::Syntax::Methods
    config.extend ControllerMacros, type: :controller

    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end

    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    DatabaseCleaner.strategy = :truncation unless driver_shares_db_connection_with_specs
  end

  config.before do
    DatabaseCleaner.start
  end

  config.append_after do
    DatabaseCleaner.clean
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
