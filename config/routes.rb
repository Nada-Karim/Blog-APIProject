Rails.application.routes.draw do
  resources :posts
  post "signup", to: "user#signup"
  post "login", to: "user#login"
  post "test", to: "user#test"
  # Add other authenticated routes here
end
