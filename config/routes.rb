Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: %i[new create]
  resource :cart, only: :show do
    post :add_item
    delete :remove_item
  end

  # Public routes
  resources :products, only: %i[index show]

  # Admin routes
  namespace :admin do
    get "dashboard", to: "dashboard#show"
    resources :products do
      member do
        post :restore
      end
    end
    resources :categories do
      member do
        post :restore
      end
    end
    resources :users, only: %i[index show edit update]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "products#index"
end
