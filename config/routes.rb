Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "posts#index"

  get "tg/auth_callback", to: "tg#auth_callback"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get "magic_link", to: "sessions#magic_link"

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "profile", to: "users#show"
  get "profile/edit", to: "users#edit"
  post "profile", to: "users#update"

  resources :posts do
    member do
      patch :approve
      patch :reject
    end
    resources :comments
  end

  resources :intros, only: [:new, :create, :update]
  resources :users, only: [:show, :update]

  direct :cdn_image do |model|
    if Rails.env.production?
      "https://#{ENV["CDN_URL"]}/#{model.key}"
    else
      Rails.application.routes.url_helpers.rails_blob_path(model, only_path: true)
    end
  end

  # mount ActiveStorageDashboard::Engine, at: "/active-storage-dashboard"
end
