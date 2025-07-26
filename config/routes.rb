Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "posts#index"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "profile", to: "users#edit"
  post "profile", to: "users#update"

  resources :sessions, only: [:index, :show, :destroy]
  resource :password, only: [:edit, :update]

  namespace :identity do
    resource :email, only: [:edit, :update]
    resource :password_reset, only: [:new, :edit, :create, :update]
  end

  resources :posts
  resources :comments
  resources :users, only: [:show, :update]
end
