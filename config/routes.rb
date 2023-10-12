require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get ':slug/status/:tweet_id', to: 'tweets#show', as: 'show_tweet'
  resources :tweets, excep: %i[edit update] do
    # collection do
    #   post :index
    # end
    resources :comments
    post 'like', to: 'tweets#like' # /tweets/:id/like
  end
  # get '/tweet/:id/like', to: 'likes#create', as: 'create_like'
  # resources :tweets, excep: %i[edit update]
  
  resources :profiles
  
  root to: 'tweets#index'
  # match '*unmatched', to: 'application#not_found_method', via: :all
end
