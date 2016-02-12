Rails.application.routes.draw do
    use_doorkeeper
    devise_for :users
    resources :pets do
        resources :comments, only: [:index, :create, :update, :destroy]
    end
    namespace :api do
        namespace :v1 do
            resources :profiles do
                get :me, on: :collection
                get :all, on: :collection
            end
            resources :pets do
                resources :comments
            end
        end
    end
    root to: 'pets#index'
end
