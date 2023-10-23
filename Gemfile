source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '3.2.1'

gem 'rails', '~> 7.1.1'
gem 'sprockets-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'jsbundling-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'redis', '~> 4.0'

gem 'devise', '~> 4.8', '>= 4.8.1'
gem 'friendly_id', '~> 5.4', '>= 5.4.2'
gem 'cssbundling-rails'
gem 'name_of_person'
gem 'sidekiq', '~> 6.5', '>= 6.5.4'
gem 'stripe'
gem 'bulma-rails', '~> 0.6.1'
gem 'simple_form', '~> 5.2'
gem 'pundit', '~> 2.3', '>= 2.3.1'
gem 'pagy'
gem 'active_storage_validations'
gem 'httparty', '~> 0.21.0'
gem 'foreman', '~> 0.87.2'
gem 'letter_avatar'
gem "mini_magick"

# feature flags
gem 'flipper'
gem 'flipper-active_record'
gem 'flipper-ui'

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'bootsnap', require: false

gem 'image_processing', '~> 1.2'

gem 'dotenv-rails', groups: %i[development test production]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  gem 'pry-stack_explorer'
  gem 'factory_bot_rails'
  gem 'pry-nav'
  gem 'faker'
  gem 'reek', '~> 6.1', '>= 6.1.4'
  gem 'rails_best_practices', '~> 1.23', '>= 1.23.2'
  gem 'rubocop', '~> 1.57', '>= 1.57.1', require: false
  gem 'rubocop-performance', '~> 1.12.0', require: false
  gem 'rubocop-rails', '~> 2.12.0', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 2.6.0', require: false
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'main'
  end
end

group :development do
  gem 'web-console'
  gem 'brakeman', '~> 6.0', '>= 6.0.1'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end


gem "dockerfile-rails", ">= 1.5", :group => :development

gem "sentry-ruby", "~> 5.12"

gem "sentry-rails", "~> 5.12"
