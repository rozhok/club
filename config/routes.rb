Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "posts#index"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  resources :sessions, only: [:index, :show, :destroy]
  resource :password, only: [:edit, :update]

  namespace :identity do
    resource :email, only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset, only: [:new, :edit, :create, :update]
  end

  resources :posts
  resources :comments
end
