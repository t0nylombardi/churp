require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/tweet/:id/like', to: 'likes#create', as: 'create_like'
  resources :tweets, excep: %i[edit update]

  resources :profiles

  devise_for :users
  root to: 'tweets#index'
end
