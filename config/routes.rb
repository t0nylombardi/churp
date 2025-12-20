# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  mount Flipper::UI.app(Flipper) => "/flipper"

  # authenticate :user, ->(u) { u.admin? } do
  #   mount Sidekiq::Web => "/sidekiq"
  # end

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: "churps#index", as: :authenticated_root
    end

    unauthenticated do
      root to: "devise/registrations#new", as: :unauthenticated_root
    end
  end

  namespace :api do
    namespace :v1 do
      devise_for :users,
        path: "users",
        defaults: { format: :json },
        controllers: {
          sessions: "api/v1/users/sessions",
          registrations: "api/v1/users/registrations"
        }

      namespace :users do
        get :me, to: "profiles#show"
      end

      resources :churps, only: %i[index show create destroy] do
        member do
          post :like
          post :rechurp
        end

        resources :comments, only: %i[create destroy]
      end
    end
  end

  resources :users, only: %i[index show] do
    member do
      get :following
      get :followers
      get :verified_followers
      get :followers_you_know
    end
  end

  resources :churps do
    member do
      post :like
      post :rechurp
    end

    resources :comments, only: %i[create destroy]
  end

  get ":slug/status/:churp_id", to: "churps#show", as: :show_churp

  resources :profiles, only: %i[index show] do
    member do
      post :follow
      post :unfollow
    end
  end

  resources :relationships, only: %i[create destroy]
  resources :mentions, only: :index
  resources :notifications, only: :index

  resource :search, only: :show, controller: :search do
    collection do
      get :hashtags
      post :suggestions
    end
  end

  get "/about", to: "static#about", as: :about
  get "/test", to: "static#test", as: :test

  get "/tos", to: "static#terms_of_service", as: :terms_of_service
  get "/privacy", to: "static#privacy_policy", as: :privacy_policy
  get "/cookies", to: "static#cookie_policy", as: :cookie_policy
  get "/ads", to: "static#ads_info", as: :ads_info

  get "/terms_of_service", to: redirect("/tos")
  get "/privacy-policy", to: redirect("/privacy")
  get "/cookie-policy", to: redirect("/cookies")
  get "/ads-info", to: redirect("/ads")

  get "up", to: "rails/health#show", as: :rails_health_check
end
