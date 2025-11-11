Rails.application.routes.draw do
  post "sign_in", to: "sessions#create"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource :password, only: [:edit, :update]
  namespace :identity do
    resource :email, only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset, only: [:new, :edit, :create, :update]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :events
  resources :community_events
  resources :recommendations
  resources :posts
  resources :rsvps
  resources :users, only: [:index, :show, :update]
  resources :groups, only: [:index, :show]
  resources :friendships do
    collection do
      get 'friends_map'
    end
  end
  resources :friend_requests
  resources :notifications
  resources :comments
  resources :user_statuses, only: [:create, :index]
  resources :images do
    collection do
      post 'profile_picture'
    end
  end
  resources :web_push_registrations

  namespace :public do
    resources :events
  end
end
