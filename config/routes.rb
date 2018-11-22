Rails.application.routes.draw do
  root 'pages#index'

  resources :floors
  resources :rooms
  resources :devices
  resources :device_types
  resources :networks
  resources :interfaces
  resources :unit_types
  resources :sensors
  resources :actuators

  get '/simulation', to: 'pages#simulation'

  # get '*path' => redirect('/')
end
