Rails.application.routes.draw do
  # devise_for :users

  # devise_scope :users do
  post 'api/auth/facebook', to: 'api/auth#facebook'
  # end

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
