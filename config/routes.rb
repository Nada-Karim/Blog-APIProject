require "sidekiq/web"
Rails.application.routes.draw do
  resources :posts do
    resources :comments
  end

  post "signup", to: "user#signup"
  post "login", to: "user#login"
  post "test", to: "user#test"
  mount Sidekiq::Web => "/sidekiq"
  # Add other authenticated routes here
end
