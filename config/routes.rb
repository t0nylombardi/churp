require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # get '/tweet/:id/like', to: 'likes#create', as: 'create_like'
  resources :tweets, excep: %i[edit update] do
    member do
      post 'like', to: 'tweets#like' # /tweets/:id/like
    end
  end

  resources :profiles

  devise_for :users
  get ':slug/:tweet_id', to: 'tweets#show', as: 'show_tweet'
  root to: 'tweets#index'
end
