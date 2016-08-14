Rails.application.routes.draw do
  devise_for :users

  get :test, to: 'static_pages#test'

  resources :alarms, only: [:create, :update, :destroy] do
    member do
      post :ring
      post :snooze
      post :stop
    end

    collection do
      get :onlines
    end
  end
end
