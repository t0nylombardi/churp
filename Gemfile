source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '3.2.1'

gem 'rails', '~> 7.0.8'
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

gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'bootsnap', require: false

gem 'image_processing', '~> 1.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'pry'
  gem 'pry-stack_explorer'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end

