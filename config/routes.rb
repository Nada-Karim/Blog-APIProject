require "sidekiq/web"
Rails.application.routes.draw do
  resources :comments
  resources :posts
  post "signup", to: "user#signup"
  post "login", to: "user#login"
  post "test", to: "user#test"
  mount Sidekiq::Web => "/sidekiq"
  # Add other authenticated routes here
end
