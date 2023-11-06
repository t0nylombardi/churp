require 'sidekiq/web'

Rails.application.routes.draw do
  get 'errors/not_found'
  get 'errors/internal_server_error'
  mount Flipper::UI.app(Flipper) => '/flipper'
  devise_for :users
  resources  :users, only: %i(index show) do
    member do
      get :following, :followers, :verified_followers, :followers_you_know
    end
  end

  # authenticate :user, ->(u) { u.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  get ':slug/status/:churp_id', to: 'churps#show', as: 'show_churp'
  resources :churps, excep: %i(edit update) do
    resources :comments, only: %i(create destroy)
    member do
      post :rechurp
    end
    post 'like', to: 'churps#like' # /churps/:id/like
  end

  resources :profiles do
    member do
      post :follow, :unfollow
    end
  end
  resources :relationships, only: %i(create destroy)

  get 'search', to: 'search#index'
  get 'search/hashtags', to: 'search#search_hashtags'
  post 'search/suggestions', to: 'search#suggestions', as: 'search_suggestions'

  get '/tos', to: 'static#terms_of_service', as: :terms_of_service
  get '/terms_of_service', to: redirect('/terms_of_service')

  get '/privacy', to: 'static#privacy_policy', as: :privacy_policy
  get '/privacy-policy', to: redirect('/privacy-policy')

  get '/cookies', to: 'static#cookie_policy', as: :cookie_policy
  get '/cookie_policy', to: redirect('/cookie-policy')

  get '/ads', to: 'static#ads_info', as: :ads_info
  get '/ads_info', to: redirect('/ads-info')

  get '/about', to: 'static#about', as: :about


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up', to: 'rails/health#show', as: :rails_health_check

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  root to: 'churps#index'
end
