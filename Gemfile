# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "3.2.2"

gem "jbuilder"
gem "jsbundling-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 6.4"
gem "rails", "~> 7.1", ">= 7.1.2"
gem "redis", "~> 4.0"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

gem "activerecord-import", "~> 1.5", ">= 1.5.1"
gem "active_storage_validations"
gem "addressable", "~> 2.8"
gem "aws-sdk-s3"
gem "bulma-rails", "~> 0.6.1"
gem "cssbundling-rails"
gem "devise", "~> 4.8", ">= 4.8.1"
gem "elasticsearch", "~> 7.17.7"
gem "foreman", "~> 0.87.2"
gem "friendly_id", "~> 5.4", ">= 5.4.2"
gem "httparty", "~> 0.21.0"
gem "letter_avatar"
gem "mini_magick"
gem "name_of_person"
gem "noticed", "~> 1.6", ">= 1.6.3"
gem "pagy"
gem "pundit", "~> 2.3", ">= 2.3.1"
gem "searchkick"
gem "sidekiq", "~> 6.5", ">= 6.5.4"
gem "simple_form", "~> 5.2"
gem "stripe"
gem "view_component", "~> 3.6"

# feature flags
gem "flipper"
gem "flipper-active_record"
gem "flipper-ui"

gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "image_processing", "~> 1.2"

gem "dotenv-rails", groups: %i[development test production]

gem "dockerfile-rails", ">= 1.5", group: :development
gem "sentry-rails", "~> 5.12"
gem "sentry-ruby", "~> 5.12"

group :development, :test do
  gem "debug", platforms: %i[mingw mswin x64_mingw jruby]
  gem "factory_bot_rails"
  gem "faker"
  gem "pry"
  gem "pry-nav"
  gem "pry-stack_explorer"
  gem "rails-controller-testing", "~> 1.0", ">= 1.0.5"
  gem "rblineprof", "~> 0.3.7"
  gem "rblineprof-report", "~> 0.0.4"
  gem "shoulda-callback-matchers", "~> 1.1", ">= 1.1.4"
  gem "shoulda-matchers", "~> 6.0"
  gem "stackprof", "~> 0.2.25"
end

group :development do
  gem "annotaterb"
  gem "brakeman", "~> 6.0", ">= 6.0.1"
  # Code linting CLI and plugins
  gem "rubocop", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "rubocop-thread_safety"
  gem "ruby_audit"
  gem "ruby-lsp-rspec"
  gem "standard"
  gem "standard-rails"
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "database_cleaner"
  gem "selenium-webdriver"
  gem "simplecov", require: false
end
