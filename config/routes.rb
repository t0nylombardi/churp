require 'sidekiq/web'

Rails.application.routes.draw do
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
  # match '*unmatched', to: 'application#not_found_method', via: :all
end
