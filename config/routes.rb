require 'sidekiq/web'

Rails.application.routes.draw do
  
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :tweets, excep: [:edit, :update]
  resources :profiles

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'tweets#index'
end
