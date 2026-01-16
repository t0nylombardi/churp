# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby File.read(".ruby-version").strip

gem "jbuilder"
gem "jsbundling-rails"
gem "jsonapi-serializer", "~> 2.2"
gem "pg"
gem "puma"
gem "rails", "~> 8.1"
gem "redis"

gem "activerecord-import"
gem "addressable"
gem "aws-sdk-s3"
gem "bcrypt", "~> 3.1.20"
gem "dry-monads", "~> 1.9"
gem "dry-struct", "~> 1.8"
gem "dry-types", "~> 1.9"
gem "foreman"
gem "friendly_id"
gem "httparty"
gem "jwt"
gem "mini_magick"
gem "name_of_person"
gem "noticed", "~> 2.8"
gem "ostruct"
gem "pagy"
gem "pundit"
gem "opensearch-ruby"
gem "searchkick"
gem "sidekiq", "~> 8.1"
gem "view_component"

gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

gem "rswag-api"
gem "rswag-ui"

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "debug", platforms: %i[windows jruby]
  gem "factory_bot_rails"
  gem "faker"
  gem "pry", "~> 0.16.0"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rswag-specs"
  gem "shoulda-callback-matchers"
  gem "shoulda-matchers"
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
