Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "posts#index"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get "magic_link", to: "sessions#magic_link"

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "profile", to: "users#show"
  get "profile/edit", to: "users#edit"
  post "profile", to: "users#update"

  resources :sessions, only: [:index, :show, :destroy]

  resources :posts do
    resources :comments
  end

  resources :intros, only: [:new, :create, :update]
  resources :users, only: [:show, :update]

  mount ActiveStorageDashboard::Engine, at: "/active-storage-dashboard"
end
