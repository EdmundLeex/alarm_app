Rails.application.routes.draw do
  devise_for :users

  get :test, to: 'static_pages#test'

  resources :alarms, only: [:create, :update, :destroy] do
    member do
      post :ring
      post :stop
    end
  end
end
