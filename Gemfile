# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "3.4.5"

gem "jbuilder"
gem "jsbundling-rails"
gem "pg"
gem "puma"
gem "rails", "~> 7.1", ">= 7.1.5.2"
gem "redis"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

gem "activerecord-import"
gem "active_storage_validations"
gem "addressable"
gem "aws-sdk-s3"
gem "bulma-rails"
gem "cssbundling-rails"
gem "devise"
gem "elasticsearch"
gem "foreman"
gem "friendly_id"
gem "httparty"
gem "letter_avatar"
gem "mini_magick"
gem "name_of_person"
gem "noticed", "~> 2.8"
gem "pagy"
gem "pundit"
gem "searchkick"
gem "sidekiq"
gem "simple_form"
gem "stripe"
gem "view_component"

# feature flags
gem "flipper"
gem "flipper-active_record"
gem "flipper-ui"

gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "image_processing"

gem "dotenv-rails", groups: %i[development test production]

gem "dockerfile-rails", group: :development
gem "sentry-rails"
gem "sentry-ruby"

group :development, :test do
  gem "debug", platforms: %i[mingw mswin x64_mingw jruby]
  gem "factory_bot_rails"
  gem "faker"
  gem "pry", "~> 0.15.2"
  gem "rspec-rails"
  gem "rails-controller-testing"
  gem "shoulda-callback-matchers"
  gem "shoulda-matchers"
  gem "ostruct", "~> 0.6.3"
end

group :development do
  gem "annotaterb"
  gem "web-console"
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "rubocop-thread_safety"
  gem "rubocop-rails-omakase", require: false
  gem "ruby_audit"
  gem "ruby-lsp-rspec"
  gem "standard"
  gem "standard-rails"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "database_cleaner"
  gem "selenium-webdriver"
  gem "simplecov", require: false
end
