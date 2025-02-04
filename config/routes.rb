Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  Rails.application.routes.draw do
    post "/uploads", to: "uploads#create"
    resources :posts, only: [ :index, :show, :create, :update, :destroy ]
    resources :users, only: [ :create ]
    resources :sessions, only: [ :create ]
    resources :password_resets, only: [ :create, :edit, :update ]
  end
end
