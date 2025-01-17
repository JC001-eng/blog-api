Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  Rails.application.routes.draw do
    resources :posts, only: [:index, :create, :destroy]
    resources :users, only: [:create]
    resources :sessions, only: [:create]
  end
end
