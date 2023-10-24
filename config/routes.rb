require 'sidekiq/web'

Rails.application.routes.draw do
  mount Flipper::UI.app(Flipper) => '/flipper'
  devise_for :users

  # authenticate :user, ->(u) { u.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end
  
  get ':slug/status/:churp_id', to: 'churps#show', as: 'show_churp'
  resources :churps, excep: %i[edit update] do
    resources :comments, only: [:create, :destroy]
    member do
      post :rechurp
    end
    post 'like', to: 'churps#like' # /churps/:id/like
  end

  resources :profiles

  root to: 'churps#index'
  get 'search', to: 'search#index'


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
