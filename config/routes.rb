require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  resources :tweets, excep: %i[edit update] do
    collection do
      post :index
    end
    resources :comments
    post 'like', to: 'tweets#like' # /tweets/:id/like
  end
  get ':slug/:tweet_id', to: 'tweets#show', as: 'show_tweet'
  
  resources :profiles
  
  root to: 'tweets#index'
end
