Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

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
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "products#index"
end
