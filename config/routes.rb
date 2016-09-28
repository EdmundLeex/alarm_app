Rails.application.routes.draw do
  devise_for :users

  get :test, to: 'static_pages#test'

  resources :alarms do
    member do
      post :ring
      post :snooze
      post :stop
    end

    collection do
      get :online
    end
  end
end
