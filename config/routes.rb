require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :tweets, excep: %i[edit update]
  resources :profiles

  devise_for :users
  root to: 'tweets#index'
end
