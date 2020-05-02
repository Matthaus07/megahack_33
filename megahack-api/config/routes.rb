Rails.application.routes.draw do
  namespace :api do
    resources :small_businesses, only: [:create, :destroy, :show, :index, :update]
    resources :users, only: [:create, :destroy, :show, :index, :update]
    resources :products, only: [:create, :destroy, :show, :index, :update]
  end
end
