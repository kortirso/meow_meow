Rails.application.routes.draw do
    devise_for :users
    resources :pets do
        resources :comments, only: [:create, :update, :destroy]
    end
    root to: 'pets#index'
end
