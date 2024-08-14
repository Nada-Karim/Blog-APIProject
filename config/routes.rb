Rails.application.routes.draw do
  post "signup", to: "user#signup"
  post "login", to: "user#login"
  post "test", to: "user#test"
  # Add other authenticated routes here
end
