Rails.application.routes.draw do
  namespace :user do
    resources :login, only: [:create]
    resources :logout, only: [:create]
  end
end
