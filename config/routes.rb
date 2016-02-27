Rails.application.routes.draw do
  devise_for :users

  resources :alarms, only: [:create, :update, :destroy] do
    member do
      post :ring
      post :stop
    end
  end
end
