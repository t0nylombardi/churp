# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '3.2.2'

gem 'jbuilder'
gem 'jsbundling-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.4'
gem 'rails', '~> 7.1', '>= 7.1.2'
gem 'redis', '~> 4.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'activerecord-import', '~> 1.5', '>= 1.5.1'
gem 'active_storage_validations'
gem 'addressable', '~> 2.8'
gem 'aws-sdk-s3'
gem 'bulma-rails', '~> 0.6.1'
gem 'cssbundling-rails'
gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'elasticsearch', '~> 7.17.7'
gem 'foreman', '~> 0.87.2'
gem 'friendly_id', '~> 5.4', '>= 5.4.2'
gem 'httparty', '~> 0.21.0'
gem 'letter_avatar'
gem 'mini_magick'
gem 'name_of_person'
gem 'noticed', '~> 1.6', '>= 1.6.3'
gem 'pagy'
gem 'pundit', '~> 2.3', '>= 2.3.1'
gem 'searchkick'
gem 'sidekiq', '~> 6.5', '>= 6.5.4'
gem 'simple_form', '~> 5.2'
gem 'stripe'
gem 'view_component', '~> 3.6'

# feature flags
gem 'flipper'
gem 'flipper-active_record'
gem 'flipper-ui'

gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)

gem 'image_processing', '~> 1.2'

gem 'dotenv-rails', groups: %i(development test production)

gem 'dockerfile-rails', '>= 1.5', group: :development
gem 'sentry-rails', '~> 5.12'
gem 'sentry-ruby', '~> 5.12'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i(mri mingw x64_mingw)
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-stack_explorer'
  %w(rspec rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support).each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'main'
  end
end

group :development do
  gem 'annotate'
  gem 'brakeman', '~> 6.0', '>= 6.0.1'
  # Code linting CLI and plugins
  gem 'rails_best_practices', '~> 1.23', '>= 1.23.2'
  gem 'reek', '~> 6.1', '>= 6.1.4'
  gem 'rspec-snapshot', '~> 2.0', '>= 2.0.1'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end
